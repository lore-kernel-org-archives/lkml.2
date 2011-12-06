Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118Ab1LFKFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:05:53 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:34119
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933037Ab1LFKFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:05:50 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4R8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LVS1DF-02-DUU-02
X-M-MSG: 
Date: Tue, 6 Dec 2011 11:05:37 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Alex Williamson <alex.williamson@redhat.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bhelgaas@google.com>
Subject: Re: [PATCH 0/2] PCI: PRI/PASSID cleanup and fix
Message-ID: <20111206100537.GH25178@amd.com>
References: <20111111170319.32668.48479.stgit@bling.home>
 <20111123104705.GC11876@amd.com>
 <20111123144510.56ff6d1d@jbarnes-desktop>
 <20111128104055.GI11876@amd.com>
 <20111205102423.476b7ce4@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111205102423.476b7ce4@jbarnes-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 10:24:23AM -0800, Jesse Barnes wrote:
> On Mon, 28 Nov 2011 11:40:55 +0100
> Joerg Roedel <joerg.roedel@amd.com> wrote:

> > Great. Can you provide a seperate branch with these changes that I can
> > pull into my tree, please? I have upcoming changes that will conflict
> > with these patches. And I would like to solve them before merge.
> 
> Ok, I pushed these to a 'pri-changes' branch, which is a superset of my
> current linux-next branch.

Great, thanks :)

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

