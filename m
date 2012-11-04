Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab2KDPVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 10:21:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50615 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494Ab2KDPVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 10:21:40 -0500
Date: Sun, 4 Nov 2012 16:21:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AMD A10: MCE Instruction Cache Error
Message-ID: <20121104152133.GA16116@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alexander Holler <holler@ahsoftware.de>,
	linux-kernel@vger.kernel.org
References: <5093A592.9070605@ahsoftware.de>
 <5093D069.20901@ahsoftware.de>
 <20121103044929.GB21829@liondog.tnic>
 <5094F5C5.1000000@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5094F5C5.1000000@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 11:45:25AM +0100, Alexander Holler wrote:
> Hmm, exactly that just happened twice in a row. Unfortunately the
> screen was already disabled (screen saving mode), so I couldn't see
> any message, if there was any. Just a dead box (not overclocked, I
> don't do such, I even had enabled the power saving mode in the BIOS,
> which seems to mean max. 3800 MHz). I think I should start getting
> nervous. :(

How do you know this happened twice if you couldn't see any message?

Also, can you enable netconsole or serial console, if possible, and try
to catch full dmesg from the boot and up until it happens.

Also, catch the dmesg of the box on the next time it reboots after the
freeze (btw, try doing a warm reboot because this is the only way we can
preserve valid error information) - if all works ok, it should decode
the MCE before the freeze (if the MCE caused it and it actually is the
reason for the freeze).

> What I meant with another priority is using something else than
> pr_emerg(), because pr_emerge() causes the message to become
> displayed on every console, at least on my F17 with default
> settings.

This is needed because we want those errors to actually be seen.

Thanks.

-- 
Regards/Gruss,
Boris.
