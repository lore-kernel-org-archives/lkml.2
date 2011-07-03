Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab1GCVcX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 17:32:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49458 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab1GCVcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 17:32:20 -0400
Message-ID: <4E10DE42.4050707@zytor.com>
Date: Sun, 03 Jul 2011 14:25:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Brian Gerst <brgerst@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: add missing verify_cpu to 32bit wakeup
References: <20110701211943.GA7042@outflux.net> <20110703121549.GA21127@elf.ucw.cz> <20110703191522.GX32221@outflux.net>
In-Reply-To: <20110703191522.GX32221@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2011 12:15 PM, Kees Cook wrote:
> 
> Well, I figured anything that shipped with
> ebba638ae723d8a8fc2f7abce5ec18b688b791d7 should get it, since it is
> a regression in the 32bit PAE with BIOS-disabled NX corner-case.
> 

Yes, but let's do the early restore... it's both more complete and simpler.

	-hpa
