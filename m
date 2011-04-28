Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503Ab1D1Nk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:40:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:55699 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab1D1NkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:40:25 -0400
Date: Thu, 28 Apr 2011 06:37:45 -0700
From: Greg KH <gregkh@suse.de>
To: "Weil, Oren jer" <oren.jer.weil@intel.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "david@woodhou.se" <david@woodhou.se>
Subject: Re: [PATCH 1/8] staging/mei: PCI device and char driver support.
Message-ID: <20110428133745.GA4861@suse.de>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
 <1303900057-21694-2-git-send-email-oren.jer.weil@intel.com>
 <20110427150507.GC24596@suse.de>
 <F28B59AD52D84B479DCA469824475335065AF92EB9@hasmsx503.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F28B59AD52D84B479DCA469824475335065AF92EB9@hasmsx503.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 08:47:04AM +0300, Weil, Oren jer wrote:
> >On Wed, Apr 27, 2011 at 01:27:30PM +0300, Oren Weil wrote:
> >> contains module entries and PCI driver and char device definitions
> >> (using file_operations, pci_driver structs).
> >
> >That's a very lame description.  Please be more verbous, like you did on
> the
> >0/8 patch, that explains what this code is and how it is accessed.
> >
> >Same goes for the other patches in this series, you need to explain things
> >more.
> 
> No problem, should I got into details in the patch description? 

Yes.
