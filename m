Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab0KOKX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:23:57 -0500
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:60034 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0KOKX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:23:56 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Mon, 15 Nov 2010 10:23:48 +0000
From: Tony Finch <dot@dotat.at>
X-X-Sender: fanf2@hermes-2.csi.cam.ac.uk
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com, virtualization@lists.osdl.org
Subject: Re: [PATCH -next] xen: fix header export to userspace
In-Reply-To: <20101113084439.d21bd0f0.randy.dunlap@oracle.com>
Message-ID: <alpine.LSU.2.00.1011151017570.8553@hermes-2.csi.cam.ac.uk>
References: <20101112130547.c2a3c2c1.sfr@canb.auug.org.au> <20101113084439.d21bd0f0.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Nov 2010, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> scripts/headers_install.pl prevents "__user" from being exported
> to userspace headers, so just use compiler.h to make sure that
> __user is defined and avoid the error.
>
> unifdef: linux-next-20101112/xx64/usr/include/xen/privcmd.h.tmp: 79: Premature EOF (#if line 33 depth 1)

I suggest the following slightly more informative message

> scripts/headers_install.pl strips "__user" when exporting headers to
> userspace and can introduce a syntax error (detected by unifdef) if
> "__user" appears in an unexpected place. Simplify by using compiler.h to
> make sure that __user is defined and avoid the error.
>
> unifdef: linux-next-20101112/xx64/usr/include/xen/privcmd.h.tmp: 79: Premature EOF (#if line 33 depth 1)

In any case,

Acked-By:	Tony Finch <dot@dotat.at>

Tony.
-- 
f.anthony.n.finch  <dot@dotat.at>  http://dotat.at/
HUMBER THAMES DOVER WIGHT PORTLAND: NORTH BACKING WEST OR NORTHWEST, 5 TO 7,
DECREASING 4 OR 5, OCCASIONALLY 6 LATER IN HUMBER AND THAMES. MODERATE OR
ROUGH. RAIN THEN FAIR. GOOD.
