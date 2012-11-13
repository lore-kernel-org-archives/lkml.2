Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab2KMFEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 00:04:38 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36982 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2KMFEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 00:04:37 -0500
Message-ID: <50A1D4E4.50308@wwwdotorg.org>
Date: Mon, 12 Nov 2012 22:04:36 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jonas Gorski <jonas.gorski@gmail.com>
CC: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        John Crispin <blogic@openwrt.org>, Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] MIPS: BCM63XX: switch to common clock and Device Tree
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com> <1352638249-29298-11-git-send-email-jonas.gorski@gmail.com>
In-Reply-To: <1352638249-29298-11-git-send-email-jonas.gorski@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2012 05:50 AM, Jonas Gorski wrote:
> Switch BCM63XX to the common clock framework and use clkdev for
> providing clock name lookups for non-DT devices.
> 
> Clocks can have a frequency and gate-bit, or none, in case they
> are just provided for drivers expecting them to be present.

> diff --git a/Documentation/devicetree/bindings/clock/bcm63xx-clock.txt b/Documentation/devicetree/bindings/clock/bcm63xx-clock.txt

A very minor nit, but it might be nice to add the DT binding
documentation before (or as part of) the patches that use them (code
that parses them, or using the bindings in .dts files)

Of course, I'm relying on my email receive order, to judge this since
the patch numbering didn't come through, so perhaps the patches are
already set up this way...
