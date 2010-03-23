Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0CWDWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 23:22:30 -0400
Received: from mail-qy0-f182.google.com ([209.85.221.182]:65032 "EHLO
	mail-qy0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab0CWDW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 23:22:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cXXiCG40Jz9sLEgoW2jpudO40Ql3aHmoCv+8xQrgdNrOdbyuRCuyV1fsN2+HQCnSpi
         8g/ldAzE3fHiawKj0MbSv4gsvAcsGfGMl6o70fiweA1wcoAQpl32XikjnIYJlf3bjcsk
         hznom4K1xRO4SFAq1tytHQb2bKMT9FEU8sjGI=
MIME-Version: 1.0
In-Reply-To: <201003222228.28268.rjw@sisk.pl>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera>
	 <hTwaxgnIZ2O.A.rhF.SQopLB@chimera>
	 <alpine.LSU.2.00.1003220319360.1726@sister.anvils>
	 <201003222228.28268.rjw@sisk.pl>
Date: Tue, 23 Mar 2010 11:22:26 +0800
Message-ID: <2375c9f91003222022q17cfc75fx3f8ebcb7d785dc42@mail.gmail.com>
Subject: Re: [Bug #15202] lockdep warning during elevator_switch
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 5:28 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday 22 March 2010, Hugh Dickins wrote:
>> On Sun, 21 Mar 2010, Rafael J. Wysocki wrote:
>> > The following bug entry is on the current list of known regressions
>> > introduced between 2.6.32 and 2.6.33.  Please verify if it still should
>> > be listed and let the tracking team know (either way).
>> >
>> > Bug-Entry   : http://bugzilla.kernel.org/show_bug.cgi?id=15202
>> > Subject             : lockdep warning during elevator_switch
>> > Submitter   : Hugh Dickins <hugh.dickins@tiscali.co.uk>
>> > Date                : 2010-01-31 23:55 (50 days old)
>> > References  : http://marc.info/?l=linux-kernel&m=126498212613051&w=4
>>
>> Yes, it is still a regression 2.6.33.1 (though fixed in 2.6.34-rc1:
>> my guess is that it will be left as a regression in 2.6.33-stable,
>> since it only happens when you have chosen CONFIG_PROVE_LOCKING=y).
>
> The policy is that we close the regression bugs after they've been fixed in the
> Linus' tree, so I'm going to close it now.

Agreed.

>
> If you want it to go into -stable, please let Greg know directly.
>

Right, but the fix for this issue is too large to go -stable, perhaps.
Lots of related fixes are needed too because of it.

Thanks.
