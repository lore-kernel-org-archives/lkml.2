Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab1KUKiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:38:11 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:51603
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755835Ab1KUKiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:38:08 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4R8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LV0AVE-02-08Q-02
X-M-MSG: 
Date: Mon, 21 Nov 2011 11:37:55 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix comparison using wrong pointer variable in dma debug
 code
Message-ID: <20111121103755.GB11040@amd.com>
References: <4EC560F6.9050906@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EC560F6.9050906@intra2net.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 08:31:02PM +0100, Thomas Jarosch wrote:
> cppcheck reported:
> [lib/dma-debug.c:248] -> [lib/dma-debug.c:248]: (style) Same expression on both sides of '=='.
> 
> Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>

Applied to iommu/fixes, thanks.


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

