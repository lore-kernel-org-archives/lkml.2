Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2HXELY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 00:11:24 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33495 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab2HXELS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 00:11:18 -0400
Date: Fri, 24 Aug 2012 05:11:08 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, ShuoX Liu <shuox.liu@intel.com>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 0/3] c-state governor changes
Message-ID: <20120824041108.GC3001@srcf.ucam.org>
References: <20120823171104.38574add@cuia.bos.redhat.com>
 <5036A67D.9090904@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5036A67D.9090904@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 02:54:05PM -0700, Arjan van de Ven wrote:
> On 8/23/2012 2:11 PM, Rik van Riel wrote:
> > This patch set is mostly there to kick off a discussion in time
> > for Kernel Summit.  When running it on my laptop, with acpi_idle,
> > I see a promising change in powertop.
> 
> be careful with acpi_idle... that will remove most of the intermediate C states the platform has,
> so the policy engine no longer has good things to chose from.

Not inherently - intel_idle typically only exports 4 C states, and many 
ACPI platforms will provide the same number, especially when on battery.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
