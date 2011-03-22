Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab1CVWHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:07:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57818 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352Ab1CVWHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:07:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 3/6] PCI / Intel IOMMU: Use syscore_ops instead of sysdev class and sysdev
Date: Tue, 22 Mar 2011 23:07:21 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
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
References: <201103100131.58206.rjw@sisk.pl> <201103220036.17824.rjw@sisk.pl> <20110322105738.GC20444@amd.com>
In-Reply-To: <20110322105738.GC20444@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103222307.21983.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 22, 2011, Joerg Roedel wrote:
> On Mon, Mar 21, 2011 at 07:36:17PM -0400, Rafael J. Wysocki wrote:
> >  drivers/pci/intel-iommu.c |   38 +++++++++-----------------------------
> >  1 file changed, 9 insertions(+), 29 deletions(-)
> 
> Looks good.

May I take that as an ACK?

> I prepare a patch to convert AMD IOMMU to syscore_ops too.

Already done.  :-)

It's a part of patch [1/6].

Thanks,
Rafael
