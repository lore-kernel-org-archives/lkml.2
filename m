Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965084Ab0GPK2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 06:28:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51885 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965066Ab0GPK2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 06:28:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XmiaMvpI8y6DB6VYPmTskyvD7nJNnokB+Uq1LPqDH0+NII2SWzFVwALrmxQg+OlZZN
         pa2rr7czzxXxiCkSg9AfvbYXMaHp+YGAEOIGww1u6JFAl/fG5je8lyAQvIAXIhrmxImV
         9Z5RpEI4BV/xfkrmiLX4zGD/nicBbLlqxqRfY=
MIME-Version: 1.0
In-Reply-To: <4C3F238A.5080701@free.fr>
References: <4C3ED059.9050508@free.fr>
	<AANLkTikEWysGAk6-hxqgecjlte-ilbait_9cvbDlz9Ue@mail.gmail.com>
	<4C3F238A.5080701@free.fr>
Date: Fri, 16 Jul 2010 20:28:28 +1000
Message-ID: <AANLkTiklxp9MIWpcYkHjQoSv3gwjMGaP569-ptn_URyo@mail.gmail.com>
Subject: Re: vga switcheroo not working on amilo Xi 3650
From: Dave Airlie <airlied@gmail.com>
To: eric.valette@free.fr
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 1:04 AM, Eric Valette <eric.valette@free.fr> wrote:
> On 15/07/2010 11:16, Dave Airlie wrote:
>
>> [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
>>
>> doesn't look good,
>
> Its because I sent the dmesg while nvidia card was forced in the BIOS. Here
> is the dmesg in hybrid mode
>
>> though I still haven't had a successful intel/nvidia switch as I lack
>> the hardware, and nobody has worked out exactly which ACPI method is
>> used to switch the MUX.
>
> You have a bunch of DSTD.dsl for the amilo including mine here
> https://bugs.launchpad.net/ubuntu/+source/xorg-server/+bug/312756
>
> I attached it for convenience
>>
>> if you can get a dmesg with i915 and nouveau loaded then open a bug on
>> bugs.kernel.org I can try and work with you to figure that out,
>
> I guess I can now fill one?

Also if you could try disabling the nvidia, with echoing OFF then ON
and post that dmesg as well.

Dave.
