Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab0FXMWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 08:22:24 -0400
Received: from 8bytes.org ([88.198.83.132]:38429 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab0FXMWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 08:22:23 -0400
Date: Thu, 24 Jun 2010 14:22:19 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Tom Lyon <pugs@lyon-about.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, avi@redhat.com, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100624122219.GD20761@8bytes.org>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com> <201006111515.53562.pugs@lyon-about.com> <20100613102339.GB4191@redhat.com> <201006171414.00878.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006171414.00878.pugs@lyon-about.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 02:14:00PM -0700, Tom Lyon wrote:
> On Sunday 13 June 2010 03:23:39 am Michael S. Tsirkin wrote:

> OK, after more investigation, I realize you are right.
> We definitely need the IOMMU protection for interrupts, and
> if we have it, a lot of the code for config space protection is pointless.
> It does seem that the Intel  intr_remapping code does what we want
> (accidentally) but that the AMD iommu code does not yet do any
> interrupt remapping.  Joerg - can you comment? On the roadmap?

Work on this is planned, but not at a high priority by now. I can
re-prioritize this item if needed.

	Joerg

