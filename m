Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1F2KBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:01:21 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51147
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751463Ab1F2KBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:01:19 -0400
Date: Wed, 29 Jun 2011 06:01:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: virtio scsi host draft specification, v3
Message-ID: <20110629100116.GB22900@infradead.org>
References: <4DEE2B15.4090809@redhat.com>
 <4DF21447.6090005@suse.de>
 <20110612075140.GB11941@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110612075140.GB11941@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 10:51:41AM +0300, Michael S. Tsirkin wrote:
> For example, if the driver is crazy enough to put
> all write requests on one queue and all barriers
> on another one, how is the device supposed to ensure
> ordering?

There is no such things as barriers in SCSI.  The thing that comes
closest is ordered tags, which neither Linux nor any mainstream OS
uses, and which we don't have to (and generally don't want to)
implement.

