Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502Ab2AKQLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:11:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297Ab2AKQL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:11:29 -0500
Date: Wed, 11 Jan 2012 14:10:00 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] kvm: set affinity hint for assigned device msi
Message-ID: <20120111161000.GA12868@amt.cnet>
References: <cover.1318358229.git.mst@redhat.com>
 <7458f62a58ad7d4022eefba4333336ba268e4ef9.1318358229.git.mst@redhat.com>
 <20111013145450.GA4143@amt.cnet>
 <20111016131223.GB17978@redhat.com>
 <20111017105859.GA20914@amt.cnet>
 <20111017133215.GA6406@redhat.com>
 <20111017160741.GA25476@amt.cnet>
 <20111017170440.GA8894@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017170440.GA8894@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 07:04:40PM +0200, Michael S. Tsirkin wrote:
> On Mon, Oct 17, 2011 at 02:07:41PM -0200, Marcelo Tosatti wrote:
> > > > Configurations to consider, all common ones used for assigned devices?
> > > 
> > > I mean, besides round robin, any other modes that
> > > have an issue? Interrupts can also be multicast,
> > > I think, but we probably don't care what happens
> > > to affinity then, as msi interrupts are probably never
> > > broadcast ...
> > 
> > There is also lowest priority, which can be used with MSI.
> 
> 
> So the following will probably address that comment?

Yes, it does. Patch looks fine.

