Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0CVBll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 21:41:41 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38671 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab0CVBlj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 21:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DgVBtCWF1fR5CA0PRLtyU3JS6Jwi0AdsDnXbDV2kDxYT8YLQKWsTk/Fzbo7OU1G7J1
         BMy6xsMa2WuhE/1gaU0/IsU7A/2k7lfHxRlVzwaNr+W52xeQVVAJla8ViX9b0v9n48RB
         j5SM8QKXBE0Xt7lftGZ8b7Vfzm5le+iHHloPg=
MIME-Version: 1.0
In-Reply-To: <20100321130426.GB15746@khazad-dum.debian.net>
References: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
	 <4BA3C07A.8030204@gmx.net>
	 <73e903671003191123h1b7e1196v336265842f1b29e5@mail.gmail.com>
	 <4BA3C461.5060209@gmx.net>
	 <de04351e1003210329w21f4731as3597245562a390d@mail.gmail.com>
	 <20100321130426.GB15746@khazad-dum.debian.net>
Date: Mon, 22 Mar 2010 09:41:38 +0800
Message-ID: <de04351e1003211841i3c3070b1ob033ee09a21dc8f1@mail.gmail.com>
Subject: Re: BUG:write data to degrade raid5
From: jin zhencheng <zhenchengjin@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Joachim Otahal <Jou@gmx.net>,
       =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>,
       neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

don't have swap on the RAID.

On Sun, Mar 21, 2010 at 9:04 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Sun, 21 Mar 2010, jin zhencheng wrote:
>> ths for your test on "Debian 2.6.26-21lenny4".
>> if you want to see the oop ,you should always write to the raid5 ,and
>> pull 2 disks out.maybe you can see the error
>>
>> i think no matter what i do ,even if i pull out all the disk , kernel
>> should not oop.
>
> You don't have swap (file or partition, doesn't matter) on that RAID, do
> you?
>
> --
>  "One disk to rule them all, One disk to find them. One disk to bring
>  them all and in the darkness grind them. In the Land of Redmond
>  where the shadows lie." -- The Silicon Valley Tarot
>  Henrique Holschuh
>
