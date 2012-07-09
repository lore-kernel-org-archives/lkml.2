Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab2GICB0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:01:26 -0400
Received: from edison.jonmasters.org ([173.255.233.168]:57596 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab2GICBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 22:01:24 -0400
Message-ID: <4FFA3B71.3020105@jonmasters.org>
Date: Sun, 08 Jul 2012 22:01:21 -0400
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi{s,z}ation of Broken Dreams
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dennis Gilmore <dgilmore@fedoraproject.org>
CC: linux-kernel@vger.kernel.org
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com> <201207071927.13135.arnd@arndb.de> <4FF93C99.80203@redhat.com> <4FF9D1E9.4050504@jonmasters.org> <20120708172419.2b2f2713@pegasus.ausil.us>
In-Reply-To: <20120708172419.2b2f2713@pegasus.ausil.us>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2012 06:24 PM, Dennis Gilmore wrote:

> I know that the architecture really is new but thats not really clear
> by adding AArch32 into the mix to represent 32 bit arm as ARM has done
> or by calling it armv8. There is enough way to confuse them already why
> confuse things more by adding yet another variable that is AArch64.
> - From my and most of the other Fedora developers that i've discussed it
> with its more like reluctant acceptance of AArch64 than thinking is a
> good idea. 

btw, for clarification of anyone who is confused by the names...the new
architecture is ARMv8. The 64-bit state is AArch64, during which the
processor executes A64 instructions. The 32-bit state is AArch32, during
which the processor executes either A32 ("ARM" version 7+) or T32
("Thumb" - I guess Thumb2+ really due to some of deprecation)
instructions. I've noticed that there appears to be a clarification
effort in which AArch64 is used as an architecture name when ARMv8 would
be confusing, which is most of the time if you don't know whether you're
referring to the new A64 instruction set or the older ones.

Perhaps this is useful if someone is trying to figure out heads or tails
of the different terms.

Jon.
