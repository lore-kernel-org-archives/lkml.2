Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab1KWKrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:47:15 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:13144
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151Ab1KWKrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:47:13 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz98dKzz1202hzz15d4R8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LV40MK-01-2AD-02
X-M-MSG: 
Date: Wed, 23 Nov 2011 11:47:05 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jbarnes@virtuousgeek.org>, <bhelgaas@google.com>
Subject: Re: [PATCH 0/2] PCI: PRI/PASSID cleanup and fix
Message-ID: <20111123104705.GC11876@amd.com>
References: <20111111170319.32668.48479.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111111170319.32668.48479.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 10:06:23AM -0700, Alex Williamson wrote:
> Alex Williamson (2):
>       PCI: More PRI/PASID cleanup
>       PCI: Enable is not exposed as a PASID capability

For both:

Reviewed-by: Joerg Roedel <joerg.roedel@amd.com>
Tested-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

