Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab0HRV1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 17:27:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34800 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab0HRV1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 17:27:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=o9i3UkZOgOMfwR3eKlMjdzGKxztUfYAl01UygncCbb+4ZI0R/InpsNbpwPX1Atw0d5
         lQQ5A62IdRqJP50GWFV8cKRZIsCFsiXGt9VZsQRTvTBDZn3wMsLdBD8WWg/YcG4zBFw5
         tGag0kVDn7t2MDyC7DulFiIpSyAWtx0STyFTo=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <AANLkTik3S91w+92rz-KdHd_U=yfuSPbDWWhD_Vu_rDR9@mail.gmail.com>
References: <201008182102.03201.maciej.rutecki@gmail.com>
	<AANLkTik3S91w+92rz-KdHd_U=yfuSPbDWWhD_Vu_rDR9@mail.gmail.com>
Date: Wed, 18 Aug 2010 22:27:14 +0100
Message-ID: <AANLkTik4=_3wSNpkfqssWsmG_yCYOPFsA-cMDBaVU4BB@mail.gmail.com>
Subject: Re: [REGRESSION] [SUSPEND] Opps during suspend to disk (probably also
 during to ram)
From: trapDoor <trapdoor6@gmail.com>
To: maciej.rutecki@gmail.com
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 8:16 PM, trapDoor <trapdoor6@gmail.com> wrote:
> On Wed, Aug 18, 2010 at 8:02 PM, Maciej Rutecki
> <maciej.rutecki@gmail.com> wrote:
>> Last known good kernel: 2.6.35
>> Failing kernel: 2.6.36-rc1
>>
>> When I try suspend to disk under 2.6.36-rc1 ("no_console_suspend" option
>> enabled) system hangs on this message:
>> http://unixy.pl/maciek/download/kernel/2.6.36-
>> rc1/zlom/suspend_issue/dsc_0001.jpg
>>
> Hello,
>
> I see on the screenshot some messages related to HID so perhaps you
> have the same issue I came across recently. If it happens so this
> commit should fix it:
> http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commitdiff;h=9c9e54a8df0be48aa359744f412377cc55c3b7d2
>
> For more details please refer to:
> https://bugzilla.kernel.org/show_bug.cgi?id=16615
> or:
> http://lkml.org/lkml/2010/8/18/92   #currently dead
>
>
>
> --
> Regards
> Tomasz B.
>

Maciej,
Just FYI I have updated the bugzilla entry
(https://bugzilla.kernel.org/show_bug.cgi?id=16615) with relevant
details.


-- 
Thanks
Tomasz
