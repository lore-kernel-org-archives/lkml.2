Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab0FBJx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:53:56 -0400
Received: from 8bytes.org ([88.198.83.132]:39815 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757040Ab0FBJxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:53:55 -0400
Date: Wed, 2 Jun 2010 11:53:54 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Tom Lyon <pugs@lyon-about.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Avi Kivity <avi@redhat.com>,
       "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, chrisw@sous-sol.org, hjk@linutronix.de,
       gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602095354.GE964@8bytes.org>
References: <20100530121944.GH27611@redhat.com> <4C04E0E0.3070006@redhat.com> <1275452987.16980.24.camel@x201> <201006012159.41344.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006012159.41344.pugs@lyon-about.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 09:59:40PM -0700, Tom Lyon wrote:
> This is just what I was thinking.  But rather than a get/set, just use two fds.
> 
> 	ioctl(vfio_fd1, VFIO_SET_DOMAIN, vfio_fd2);
> 
> This may fail if there are really 2 different IOMMUs, so user code must be
> prepared for failure,  In addition, this is strictlyupwards compatible with 
> what is there now, so maybe we can add it later.

How can this fail with multiple IOMMUs? This should be handled
transparently by the IOMMU driver.

	Joerg

