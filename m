Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104Ab2ILP2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:28:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389Ab2ILP2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:28:10 -0400
Date: Wed, 12 Sep 2012 12:27:56 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 12/12] KVM: indicate readonly access fault
Message-ID: <20120912152756.GA18155@amt.cnet>
References: <5032F8FD.2020306@linux.vnet.ibm.com>
 <5032FA78.9040405@linux.vnet.ibm.com>
 <5034CB60.30107@redhat.com>
 <5034D4E3.2080801@linux.vnet.ibm.com>
 <5048AE96.3050909@redhat.com>
 <5049C4D7.50101@linux.vnet.ibm.com>
 <20120910223140.GA24275@amt.cnet>
 <504F01DE.20505@redhat.com>
 <20120911143901.GA11792@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911143901.GA11792@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 11:39:01AM -0300, Marcelo Tosatti wrote:
> On Tue, Sep 11, 2012 at 12:18:22PM +0300, Avi Kivity wrote:
> > > The same can happen with slot deletion, for example. 
> > > 
> > > Userspace (which performed the modification which can result in faults
> > > to non-existant/read-only/.../new-tag memslot), must handle the faults 
> > > properly or avoid the possibility for reference to memslot information 
> > > from the past.
> > > 
> > > I think its worthwhile to add a note about this in the API
> > > documentation: "The user of this interface is responsible for handling 
> > > references to stale memslot information, either by handling
> > > exit notifications which reference stale memslot information or not
> > > allowing these notifications to exist by stopping all vcpus in userspace
> > > before performing modifications to the memslots map".
> > 
> > Or we can drop the new interface and rely on userspace to perform the
> > lookup under its own locking rules.
> > 
> > It's slow, but writes to ROM or ROM/device are rare anyway.
> 
> Lookup what information? 

Ping? 


