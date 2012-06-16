Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750872Ab2FPEAc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 00:00:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57976 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab2FPEAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 00:00:31 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] devicetree: add helper inline for retrieving a node's full name
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1339801070.9220.211.camel@pasglop>
References: <1339782625-28192-1-git-send-email-grant.likely@secretlab.ca> <1339801070.9220.211.camel@pasglop>
Date: Fri, 15 Jun 2012 22:00:28 -0600
Message-Id: <20120616040028.C83513E0ACE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jun 2012 08:57:50 +1000, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Fri, 2012-06-15 at 11:50 -0600, Grant Likely wrote:
> > The pattern (np ? np->full_name : "<none>") is rather common in the
> > kernel, but can also make for quite long lines.  This patch adds a new
> > inline function, of_node_full_name() so that the test for a valid node
> > pointer doesn't need to be open coded at all call sites.
> 
> s/of_node_full_name/of_node_path ?

It would be nicer to have the shorter name, but the data member is
already named full_name, so I'd rather use the same for the function
name (unless you argue strongly against, it's not something I'm going
to fight about).

g.
