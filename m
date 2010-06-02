Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab0FBQyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 12:54:01 -0400
Received: from sous-sol.org ([216.99.217.87]:46186 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932786Ab0FBQx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 12:53:59 -0400
Date: Wed, 2 Jun 2010 09:53:21 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>, "Michael S. Tsirkin" <mst@redhat.com>,
       Tom Lyon <pugs@cisco.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, chrisw@sous-sol.org, hjk@linutronix.de,
       gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602165321.GU8301@sequoia.sous-sol.org>
References: <20100531171007.GA6516@redhat.com>
 <4C04C085.1030107@redhat.com>
 <20100601095532.GA9178@redhat.com>
 <4C04E0E0.3070006@redhat.com>
 <20100601104651.GA9415@redhat.com>
 <4C050013.2020701@redhat.com>
 <20100602094527.GD964@8bytes.org>
 <4C062928.8040003@redhat.com>
 <20100602100404.GF964@8bytes.org>
 <4C063ECB.8010706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C063ECB.8010706@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity (avi@redhat.com) wrote:
> The interface would only work for clients which support it: kvm,
> vhost, and iommu/devices with restartable dma.

BTW, there is no such thing as restartable dma.  There is a provision in
new specs (read: no real hardware) that allows a device to request pages
before using them.  So it's akin to demand paging, but the demand is an
explicit request rather than a page fault.

thanks,
-chris
