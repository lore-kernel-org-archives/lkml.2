Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317Ab2KAVhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:37:34 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49399 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124Ab2KAVhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:37:32 -0400
Date: Thu, 1 Nov 2012 22:37:26 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 00/19 v3] Improve IRQ remapping abstraction in x86 core
 code
Message-ID: <20121101213726.GC31453@breakpoint.cc>
References: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; x-action=pgp-signed
Content-Transfer-Encoding: 8bit
In-Reply-To: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On Wed, Sep 26, 2012 at 12:44:32PM +0200, Joerg Roedel wrote:
> Hi,
Hi Jörg,

> here is the third version of the patch-set to improve the abstraction
> of interrupt remapping in the x86 core code. A more detailed description

I went through the whole series and looks good. The patches
- - x86, io_apic: Introduce x86_io_apic_ops.disable()
- - x86, io_apic: Introduce x86_io_apic_ops.print_entries for debugging
- - x86, msi: Use IRQ remapping specific setup_msi_irqs routine
- - x86, io_apic: Convert setup_ioapic_entry to function pointerx86, io_apic:
- - x86, io_apic: Move irq_remapping_enabled checks out of check_timer()
- - x86, io-apic: Move CONFIG_IRQ_REMAP code out of x86 core

trigger some checkpatch warnings, mostly the 80char thingy. I don't care about
the "quoted string split across lines" warning.
Besides the minor thingy I just mentioned,
 Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Sebastian
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQkuuWAAoJEHuW6BYqjPXRnVwP/08DxdazUY4SOPIvBK4+gZh7
3VW5EdTLjBSYnaWEFccwhaqqq6FgJ5MfJ862sSXUpejjApDFQdOQPlZmIwfY5lFh
n3z20/6Nvum6mCvZLUEi7D+cQZ42ZWfyQW62dBxwQvw6sex884f5DUFqftlCUJzA
qlCBXoqVRkW03stfH8j4rDI+lponuR6P1m7hdV4r7CB95RthME/ZOpHQ3G2qSTRF
7mCRJ6eP7eLdZSichWHuhyXcil1uADglPw8m9PKtEE7AW9satiXO/b/pEFiDDdNr
xcb7Sc3OalccYVe7/Hs5WypNg05e/N4WHuTx4Y4gD2f6pHJA64bbZ6+3nmMJBt9y
NbCzuDg1dgXFG0YQkPCbULGSnu/Z6DKnryrPvmRhCQUS7w8pXMOfhdKz8q2v+l8G
riej/ZGHCGbf0UmvM+HguTjuTTCGMdvkCRGpx/UwVvy8Ll5sb0o73ORw25hdPHdD
VGaximc4jmRBTSMB7ncOCMYOjTp6CKhG2ZvtA6q+JDS+GGTv3tfEBHri2STzZ7BY
SrG8boABWJq39xxsivltimMJFa9IBCWpTyb/yG7T4I4ypOwI2QSdRob/Rs/BprHI
SdzYlj2BFiR3ToF8WDXrMw9ywkVG6QL1oVrUDA+LHaBZO574KW/LMMuktYCj+gmY
mQEcW6k8kS39uBtiL0Kh
=tIW6
-----END PGP SIGNATURE-----
