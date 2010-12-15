Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516Ab0LOCmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 21:42:53 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64694 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab0LOCmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 21:42:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EyW7wGoT8hFKTLNaW4765zvlhges+j1TdZRNlqRGZic3TwZrPMSqMBDrDj6gjW9y5E
         L0wdPKszIuAIpiRitihWBQshetaelVi24lorC1lMlAMY34MlYP1CdzkcF2mRAieYKzl3
         tXwzpccTtepxFogFJWWCU40zSywLuX0wcKmtw=
MIME-Version: 1.0
In-Reply-To: <20101214214306.GC5900@hanuman.home.ifup.org>
References: <20101212131550.GA2608@darkstar>
	<AANLkTinaNjPjNbxE+OyRsY_jJxDW-pwehTPgyAWzqfzd@mail.gmail.com>
	<20101214003024.GA3575@hanuman.home.ifup.org>
	<AANLkTi=ic4i+whV7-gtA7jvWJkPE+bizLdra6OMDf6Cp@mail.gmail.com>
	<20101214214306.GC5900@hanuman.home.ifup.org>
Date: Wed, 15 Dec 2010 10:42:50 +0800
Message-ID: <AANLkTimJrj6TY4BQ1BCd2USjudmLiY9AntWXmRzFWgn_@mail.gmail.com>
Subject: Re: [PATCH] bttv: fix mutex use before init
From: Dave Young <hidave.darkstar@gmail.com>
To: Brandon Philips <brandon@ifup.org>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Chris Clayton <chris2553@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 5:43 AM, Brandon Philips <brandon@ifup.org> wrote:
> On 21:56 Tue 14 Dec 2010, Torsten Kaiser wrote:
>> On Tue, Dec 14, 2010 at 1:30 AM, Brandon Philips <brandon@ifup.org> wrote:
>> > On 17:13 Sun 12 Dec 2010, Torsten Kaiser wrote:
>> >>  * change &fh->cap.vb_lock in bttv_open() AND radio_open() to
>> >> &btv->init.cap.vb_lock
>> >>  * add a mutex_init(&btv->init.cap.vb_lock) to the setup of init in bttv_probe()
>> >
>> > That seems like a reasonable suggestion. An openSUSE user submitted this
>> > bug to our tracker too. Here is the patch I am having him test.
>> >
>> > Would you mind testing it?
>>
>> No. :-)
>>
>> Without this patch (==vanilla 2.6.37-rc5) I got 2 more OOPSe by
>> restarting hal around 20 times.
>> After applying this patch, I did not see a single OOPS after 100 restarts.
>> So it looks like the fix is correct.
>
> Dave, Torsten- Great thanks for testing, can I get both you and Dave's
> Tested-by then?

Feel free to add my tested-by line for this, Thanks

>
> Mauro- can you please pick up this patch?
>
> Cheers,
>
>        Brandon
>



-- 
Regards
dave
