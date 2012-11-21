Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab2KVUb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:31:29 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:32842 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756796Ab2KVUbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:31:23 -0500
Message-ID: <1353533751.24807.49.camel@joe-AO722>
Subject: Re: [Pv-drivers] [PATCH 01/12] VMCI: context implementation.
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: George Zhang <georgezhang@vmware.com>, pv-drivers@vmware.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Date: Wed, 21 Nov 2012 13:35:51 -0800
In-Reply-To: <20121121212908.GA16131@dtor-ws.eng.vmware.com>
References: <20121121202625.13252.86346.stgit@promb-2n-dhcp175.eng.vmware.com>
	 <20121121203109.13252.92744.stgit@promb-2n-dhcp175.eng.vmware.com>
	 <1353531886.24807.43.camel@joe-AO722>
	 <20121121212908.GA16131@dtor-ws.eng.vmware.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-21 at 13:29 -0800, Dmitry Torokhov wrote:
> Hi Joe,

Howdy.

> On Wed, Nov 21, 2012 at 01:04:46PM -0800, Joe Perches wrote:
> > On Wed, 2012-11-21 at 12:31 -0800, George Zhang wrote:
> > > +	context = kzalloc(sizeof(*context), GFP_KERNEL);
> > > +	if (!context) {
> > > +		pr_warn("Failed to allocate memory for VMCI context.\n");
> > 
> > OOM logging messages aren't necessary as alloc failures
> > are already logged with a stack trace.
> > 
> 
> Are we sure we are going to keep this policy forever?

As in geological eras?  Hard to say.  It's been there awhile.
If more OOM logging messages are removed, it's more likely
for the core facility to stay.

There is an __GFP_NOWARN override to avoid the stack trace.

> I'd rather keep the OOM warnings.

Your choice.

cheers, Joe

