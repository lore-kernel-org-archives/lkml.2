Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab0KSXR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 18:17:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36762 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab0KSXR4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 18:17:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FL0ikLc+IZCGcNH4n1TcJNtXQ8+nmClgWiDM8X9KqxfJ1P3+VZmkzcPBIoAnnTHsYt
         ymoO1SoVb4TTBuYHIJV0M2Om5eRAVpXS/CSUk3GcSzlTPtzMWkfIwQaBaVX82aaxk4H/
         0goq1ssvovPYspRmT6CHDPljyinZINKCEj3ZI=
MIME-Version: 1.0
In-Reply-To: <4CE70543.2000206@teksavvy.com>
References: <tTUH_XeInOH.A.dMF.c3b5MB@chimera>
	<4CE5C919.7090504@teksavvy.com>
	<AANLkTi=8G7pNA7QTxaXDWKrWrCERPfmKU+nLJWCA=JUH@mail.gmail.com>
	<4CE7006E.4040102@teksavvy.com>
	<AANLkTim9aXi1_EJyh2f-+X4HnNWJ3uk2z=P6m1hQso5a@mail.gmail.com>
	<4CE70543.2000206@teksavvy.com>
Date: Fri, 19 Nov 2010 18:17:54 -0500
Message-ID: <AANLkTi==0+pNswCwfgo5v5tKA+Qkq7UfRdH4ftEqx7rf@mail.gmail.com>
Subject: Re: 2.6.37-rc2-git4: Reported regressions 2.6.35 -> 2.6.36
From: Alex Deucher <alexdeucher@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 6:16 PM, Mark Lord <kernel@teksavvy.com> wrote:
> On 10-11-19 05:58 PM, Alex Deucher wrote:
>>
>> On Fri, Nov 19, 2010 at 5:55 PM, Mark Lord<kernel@teksavvy.com>  wrote:
>>
>>> It now comes back at resume time.
>>
>> So that patch helped?
>
> I think so.  It didn't used to resume from suspend with 2.6.36, and now it
> does.
>
>>> But suffers long delays (also sometimes with 2.6.35) doing this:
>>>
>>> [drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 5secs
>>> aborting
>>> [drm:atom_execute_table_locked] *ERROR* atombios stuck executing E576
>>> (len
>>> 105, WS 12, PS 8) @ 0xE5C4
>>> [drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 5secs
>>> aborting
>>> [drm:atom_execute_table_locked] *ERROR* atombios stuck executing ECD2
>>> (len
>>> 86, WS 4, PS 0) @ 0xED05
>>> [drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 5secs
>>> aborting
>>> [drm:atom_execute_table_locked] *ERROR* atombios stuck executing E576
>>> (len
>>> 105, WS 12, PS 8) @ 0xE5C4
>>> PM: resume of devices complete after 15718.253 msecs
>>>
>>
>> It's be nice if you could bisect to track down when those started.
>
> It'd be even nicer if they hadn't started.  :)
>
> What kernel release first had that atom/ops table in it?  I'll try that.
>

2.6.31 or 32 was when radeon kms got merged IIRC.

Alex
