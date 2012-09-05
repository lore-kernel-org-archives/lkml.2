Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab2IEOvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:51:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab2IEOvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:51:21 -0400
Date: Wed, 5 Sep 2012 17:52:43 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 0/2] kvm: level irqfd support
Message-ID: <20120905145243.GB11048@redhat.com>
References: <20120821190800.24958.74812.stgit@bling.home>
 <504764DE.5080202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504764DE.5080202@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 05:42:38PM +0300, Avi Kivity wrote:
> On 08/21/2012 10:28 PM, Alex Williamson wrote:
> > Here's the much anticipated re-write of support for level irqfds.  As
> > Michael suggested, I've rolled the eoi/ack notification fd into
> > KVM_IRQFD as a new mode.  For lack of a better name, as there seems to
> > be objections to associating this specifically with an EOI or an ACK,
> > I've name this OADN or "On Ack, De-assert & Notify".
> 
> Perhaps we can call it "resample", since this is what it is doing.
> irqfd tells kvm that the line as been asserted, resample tells the
> caller to check again.

Sounds good.

> -- 
> error compiling committee.c: too many arguments to function
