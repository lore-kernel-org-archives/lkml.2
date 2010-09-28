Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180Ab0I1KVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 06:21:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886Ab0I1KV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 06:21:29 -0400
Date: Tue, 28 Sep 2010 12:14:24 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Tom Lyon <pugs@cisco.com>, linux-pci@vger.kernel.org,
        jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
        joro@8bytes.org, hjk@linutronix.de, avi@redhat.com, gregkh@suse.de,
        chrisw@sous-sol.org
Subject: Re: [PATCH 3/3] VFIO V4: VFIO driver: Non-privileged user level PCI
 drivers
Message-ID: <20100928101424.GL12472@redhat.com>
References: <4c9a72a0.u2cnjUB7QZ91tLeo%pugs@cisco.com>
 <20100927115420.GA7427@redhat.com>
 <1285621069.4951.61.camel@x201>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285621069.4951.61.camel@x201>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 02:57:49PM -0600, Alex Williamson wrote:
> On Mon, 2010-09-27 at 13:54 +0200, Michael S. Tsirkin wrote:
> > On Wed, Sep 22, 2010 at 02:18:24PM -0700, Tom Lyon wrote:
> > > 
> > > Signed-off-by: Tom Lyon <pugs@cisco.com>
> > 
> > Some comments on the pci bits:
> > 
> > After going over them for the Nth time - something needs to be done
> > with the rvirt/write tables. I doubt anyone besides me and you
> > has gone over them: 
> 
> /me bites tongue...

Ouch
I figured if anyone looked at them he'd have complained :)

-- 
MST
