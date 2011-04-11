Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1DKGUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 02:20:51 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:10597
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab1DKGUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 02:20:48 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4Rz32i637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJH5M7-01-0NG-02
X-M-MSG: 
Date: Mon, 11 Apr 2011 08:20:29 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Rolf Eike Beer <eike@sf-mail.de>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/5] PCI: Move ATS declarations in seperate header file
Message-ID: <20110411062029.GG23633@amd.com>
References: <1302250630-8183-1-git-send-email-joerg.roedel@amd.com>
 <1302250630-8183-2-git-send-email-joerg.roedel@amd.com>
 <4435339.aQcLV4iHRH@donald.sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4435339.aQcLV4iHRH@donald.sf-tec.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 02:33:04PM -0400, Rolf Eike Beer wrote:
> Am Freitag, 8. April 2011, 10:17:06 schrieb Joerg Roedel:
> > This patch moves the relevant declarations from the local
> > header file in drivers/pci to a more accessible locations so
> > that it can be used by the AMD IOMMU driver too.
> > The file is named pci-ats-pri.h because support for the PCI
>                     ^^^^^^^^^^^^^
> 
> >  include/linux/pci-ats.h   |   52
>                  ^^^^^^^^^
> 
> Ehm, no, it is not ;)

Right, I renamed the file at some point and forgot to change it in the
commit-msg too. I'll fix that on the next rebase :)

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

