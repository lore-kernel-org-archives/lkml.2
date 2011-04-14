Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab1DNU2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:28:24 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36292 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1DNU2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:28:22 -0400
Subject: Re: [RFC][PATCH] virtio balloon: kill tell-host-first logic
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
In-Reply-To: <20110412164341.GQ13631@amit-x200.redhat.com>
References: <20110407174325.ED21C82B@kernel>
	 <20110411110131.GA23123@redhat.com> <1302559871.7286.16749.camel@nimitz>
	 <20110412054330.GH26678@amit-x200.redhat.com>
	 <1302625352.8321.2126.camel@nimitz>
	 <20110412164341.GQ13631@amit-x200.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 14 Apr 2011 13:28:17 -0700
Message-ID: <1302812897.16562.809.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 22:13 +0530, Amit Shah wrote:
> On (Tue) 12 Apr 2011 [09:22:32], Dave Hansen wrote:
> > On Tue, 2011-04-12 at 11:13 +0530, Amit Shah wrote:
> > > Sure, the only contention was on the commit message, where you stated
> > > modern qemus set this... qemu doesn't, and it should.  Care to do a
> > > patch for that? 
> > 
> > If Rusty hasn't pushed the commit out anywhere, we can still amend the
> > commit.  Otherwise, we're in a _bit_ of a pickle since you can't patch
> > git logs. :)
> 
> I should've been clearer: care to do the qemu patch? :-)

What do we want to do to qemu, though?  Set the bit?

-- Dave

