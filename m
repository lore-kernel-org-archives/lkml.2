Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860Ab0GOJQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 05:16:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47859 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802Ab0GOJQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 05:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Mi1xPeDsk3iy1dFIdcL43AL13reUnacsCXyYps2Oqf7WGVS1yyBitmwsQQFNK1OKTU
         TZodiJvn7QRTKahkP75dNOB2Lp0ReQ2t4ZdAXtimRnRHFDVEWsakWksZtSsEaU/PIeMg
         LCOHMWmeBV6Nj2skROCwffgT3Y1/ZwRj4g1q4=
MIME-Version: 1.0
In-Reply-To: <4C3ED059.9050508@free.fr>
References: <4C3ED059.9050508@free.fr>
Date: Thu, 15 Jul 2010 19:16:10 +1000
Message-ID: <AANLkTikEWysGAk6-hxqgecjlte-ilbait_9cvbDlz9Ue@mail.gmail.com>
Subject: Re: vga switcheroo not working on amilo Xi 3650
From: Dave Airlie <airlied@gmail.com>
To: eric.valette@free.fr
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 7:09 PM, Eric Valette <eric.valette@free.fr> wrote:
> Hi david,
>
> As I saw some changes in the .35, I tried again on amilo xi 3650. As you
> will see its a Intel/Nvidia hybrid graphic laptop.
>
> When I use the delayed switch option, and restart X via the kdm restart X
> server option, I see the message of the switch and then it hangs rock solid.
> I'm forced to push on the power button for 5 s.
>
> vga_switcheroo: client 0 refused switch <== exiting the kdm session
> vga_switcheroo: setting delayed switch to client 1
> vga_switcheroo: processing delayed switch to 1 <== restarting X server
>
>
> If I use the bios, to force the cards, both settings works correctly, hybrid
> mode also works correctly as long as I use the Intel card but I cannot
> activate dynamically the nvidia one via vga switcheroo.
>
> Problem is that to have the hdmi output on this laptop I'm forced to use the
> nvidia driver and my kid like to see their film on TV...

[drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!

doesn't look good,

though I still haven't had a successful intel/nvidia switch as I lack
the hardware, and nobody has worked out exactly which ACPI method is
used to switch the MUX.

if you can get a dmesg with i915 and nouveau loaded then open a bug on
bugs.kernel.org I can try and work with you to figure that out,

Dave.
