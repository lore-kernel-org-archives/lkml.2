Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab2KVS5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:57:16 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:35785 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753232Ab2KVS5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:57:14 -0500
Date: Wed, 21 Nov 2012 13:29:08 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Joe Perches <joe@perches.com>
Cc: George Zhang <georgezhang@vmware.com>, pv-drivers@vmware.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 01/12] VMCI: context implementation.
Message-ID: <20121121212908.GA16131@dtor-ws.eng.vmware.com>
References: <20121121202625.13252.86346.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121121203109.13252.92744.stgit@promb-2n-dhcp175.eng.vmware.com>
 <1353531886.24807.43.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353531886.24807.43.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Wed, Nov 21, 2012 at 01:04:46PM -0800, Joe Perches wrote:
> On Wed, 2012-11-21 at 12:31 -0800, George Zhang wrote:
> > +	context = kzalloc(sizeof(*context), GFP_KERNEL);
> > +	if (!context) {
> > +		pr_warn("Failed to allocate memory for VMCI context.\n");
> 
> OOM logging messages aren't necessary as alloc failures
> are already logged with a stack trace.
> 

Are we sure we are going to keep this policy forever? I'd rather keep
the OOM warnings.

Thanks.

-- 
Dmitry
