Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab0G1WDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 18:03:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab0G1WDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 18:03:40 -0400
Date: Thu, 29 Jul 2010 00:57:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Tom Lyon <pugs@cisco.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
        chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de,
        avi@redhat.com, gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH V3] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100728215739.GA9671@redhat.com>
References: <4c40d618./j7HFMCg9NusCIiB%pugs@cisco.com>
 <201007271513.15093.pugs@cisco.com>
 <20100727235322.GB19930@redhat.com>
 <201007281414.22335.pugs@cisco.com>
 <1280354222.3919.12.camel@x201>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280354222.3919.12.camel@x201>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 03:57:02PM -0600, Alex Williamson wrote:
> 
> Something like GET_MSIX_VECTORS seems like a user library routine to me.
> The PCI config space is well specified and if we try to do more than
> shortcut trivial operations (like getting the BAR length), we risk
> losing functionality.  And for my purposes, translating to and from a
> made up API to PCI for the guest seems like a pain.

Won't a userspace library do just as well for you?

