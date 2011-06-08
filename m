Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab1FHLDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 07:03:38 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:39314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1FHLDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 07:03:37 -0400
Subject: Re: [PATCH v3] dma-debug: print some unfreed allocations
From: Johannes Berg <johannes@sipsolutions.net>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110523123508.GC27867@amd.com>
References: <1305052944.3544.8.camel@jlt3.sipsolutions.net>
	 <1305118077.3416.5.camel@jlt3.sipsolutions.net>
	 <20110516110029.GC31309@amd.com>
	 <1305758908.8827.3.camel@jlt3.sipsolutions.net>
	 <20110519081931.GM31309@amd.com>
	 <1305909418.4640.13.camel@jlt3.sipsolutions.net>
	 <20110523123508.GC27867@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 13:03:36 +0200
Message-ID: <1307531016.3961.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 14:35 +0200, Roedel, Joerg wrote:

> > +#ifdef CONFIG_STACKTRACE
> > +	num_show_pending_dent = debugfs_create_u32("num_show_pending", 0644,
> > +						   dma_debug_dent,
> > +						   &num_show_pending);
> > +	if (!num_show_pending_dent)
> > +		goto out_err;
> > +#endif
> 
> Hmm, thinking more about this, do we need to introduce a new variable at
> all? It should fit well into the dma-api/all_errors and
> dma-api/num_errors configurables. 

I see something similar was merged printing just the first one (and
without stack trace it seems?). Are you still interested in this?

johannes

