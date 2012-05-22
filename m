Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2EVVbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 17:31:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:18080 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab2EVVbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 17:31:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="146446765"
Date: Tue, 22 May 2012 23:40:24 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Seth Heasley <seth.heasley@intel.com>, linux-kernel@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>
Subject: Re: [PATCH 3/3] lpc_sch: Add Intel Centerton Multifunction Device
 support
Message-ID: <20120522214024.GC10210@sortiz-mobl>
References: <1334696962-3642-1-git-send-email-seth.heasley@intel.com>
 <20120509140111.GD1794@sortiz-mobl>
 <CACxGe6tJry45w8_czwoXTA-Lo=uLO8HiuETWPebBQ0_z6cnASA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACxGe6tJry45w8_czwoXTA-Lo=uLO8HiuETWPebBQ0_z6cnASA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Fri, May 18, 2012 at 04:44:45PM -0600, Grant Likely wrote:
> On Wed, May 9, 2012 at 8:01 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > Hi Seth,
> >
> > On Tue, Apr 17, 2012 at 02:09:22PM -0700, Seth Heasley wrote:
> >> This patch adds the Intel Centerton processor DeviceID for the Integrated Legacy Block.  The ILB provides GPIO, SMBus, and Watchdog functionality. The ILB DeviceID is defined in include/linux/pci_ids.h.
> >>
> > Patch applied to my for-next branch, after removing this chunk (That should be
> > part of your watchdog driver submission):
> 
> Hi Samuel,
> 
> Have you applied the gpio patch also [patch 2/3]?  It also depends on
> the pci device id, so it best go via your tree with the other two.
Yes, it's on my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
