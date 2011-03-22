Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab1CVK5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:57:52 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:48153
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751196Ab1CVK5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:57:46 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz98dNzz1202hzz15d4Rz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LIGH41-01-BJT-02
X-M-MSG: 
Date: Tue, 22 Mar 2011 11:57:38 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>, Avi Kivity <avi@redhat.com>,
        Kay Sievers <kay.sievers@suse.de>, Dave Jones <davej@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 3/6] PCI / Intel IOMMU: Use syscore_ops instead of
 sysdev class and sysdev
Message-ID: <20110322105738.GC20444@amd.com>
References: <201103100131.58206.rjw@sisk.pl>
 <201103122212.40828.rjw@sisk.pl>
 <201103220031.22729.rjw@sisk.pl>
 <201103220036.17824.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201103220036.17824.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 07:36:17PM -0400, Rafael J. Wysocki wrote:
>  drivers/pci/intel-iommu.c |   38 +++++++++-----------------------------
>  1 file changed, 9 insertions(+), 29 deletions(-)

Looks good. I prepare a patch to convert AMD IOMMU to syscore_ops too.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

