Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab1K1KlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 05:41:05 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:12494
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608Ab1K1KlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 05:41:02 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4R8275bhz2dh668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LVD9O9-02-AF3-02
X-M-MSG: 
Date: Mon, 28 Nov 2011 11:40:55 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Alex Williamson <alex.williamson@redhat.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bhelgaas@google.com>
Subject: Re: [PATCH 0/2] PCI: PRI/PASSID cleanup and fix
Message-ID: <20111128104055.GI11876@amd.com>
References: <20111111170319.32668.48479.stgit@bling.home>
 <20111123104705.GC11876@amd.com>
 <20111123144510.56ff6d1d@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111123144510.56ff6d1d@jbarnes-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 02:45:10PM -0800, Jesse Barnes wrote:
> On Wed, 23 Nov 2011 11:47:05 +0100
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Fri, Nov 11, 2011 at 10:06:23AM -0700, Alex Williamson wrote:
> > > Alex Williamson (2):
> > >       PCI: More PRI/PASID cleanup
> > >       PCI: Enable is not exposed as a PASID capability
> > 
> > For both:
> > 
> > Reviewed-by: Joerg Roedel <joerg.roedel@amd.com>
> > Tested-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> Ok, thanks guys.  I'll queue these up after Thanksgiving.
> 
> -- 
> Jesse Barnes, Intel Open Source Technology Center

Great. Can you provide a seperate branch with these changes that I can
pull into my tree, please? I have upcoming changes that will conflict
with these patches. And I would like to solve them before merge.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

