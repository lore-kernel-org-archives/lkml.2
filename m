Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab2DYP2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:28:55 -0400
Received: from exchange.thenap.com ([209.190.0.21]:4961 "EHLO
	EXCHANGE.thenap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2DYP2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:28:53 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2012 11:28:53 EDT
From: Drew Weaver <drew.weaver@thenap.com>
To: "'Thomas Jarosch'" <thomas.jarosch@intra2net.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Charlie Suffin <charlie.suffin@stratus.com>
Date: Wed, 25 Apr 2012 11:23:27 -0400
Subject: RE: [PATCH] pci: Add quirk for still enabled interrupts on Intel
 Sandy Bridge GPUs
Thread-Topic: [PATCH] pci: Add quirk for still enabled interrupts on Intel
 Sandy Bridge GPUs
Thread-Index: Ac0i9zRMpky74yPqSEiNSKWofqhBKwAABc6Q
Message-ID: <F3318834F1F89D46857972DD4B411D7005324C00C5@exchange>
References: <4EDFD5BB.1050906@intra2net.com>
 <201204251722.14877.thomas.jarosch@intra2net.com>
In-Reply-To: <201204251722.14877.thomas.jarosch@intra2net.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah it is very unfortunate that this hasn't been fixed in the BIOS.

-----Original Message-----
From: Thomas Jarosch [mailto:thomas.jarosch@intra2net.com] 
Sent: Wednesday, April 25, 2012 11:22 AM
To: linux-pci@vger.kernel.org
Cc: Jesse Barnes; linux-kernel@vger.kernel.org; Drew Weaver; Charlie Suffin
Subject: Re: [PATCH] pci: Add quirk for still enabled interrupts on Intel Sandy Bridge GPUs

On Wednesday, 7. December 2011 22:08:11 Thomas Jarosch wrote:
> Some BIOS implementations leave the Intel GPU interrupts enabled, even 
> though no one is handling them (f.e. i915 driver is never loaded).
> Additionally the interrupt destination is not set up properly and the 
> interrupt ends up -somewhere-.
>
> These spurious interrupts are "sticky" and the kernel disables the 
> (shared) interrupt line after 100.000+ generated interrupts.

Just a small heads up: Boards with the new Intel Ivy bridge chipset are affected, too. Currently known to be affected is

    Intel Desktop Board DH77EB


Would be nice if Intel fixes the shared BIOS code...

Thanks to Drew Weaver for reporting the issue. I currently don't have time to prepare another quirk.

Best regards
Thomas Jarosch
