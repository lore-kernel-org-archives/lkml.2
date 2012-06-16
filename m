Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab2FPFAM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 01:00:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:54003 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab2FPFAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 01:00:10 -0400
Message-ID: <1339822770.9220.215.camel@pasglop>
Subject: Re: [PATCH] devicetree: add helper inline for retrieving a node's
 full name
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 16 Jun 2012 14:59:30 +1000
In-Reply-To: <20120616040028.C83513E0ACE@localhost>
References: <1339782625-28192-1-git-send-email-grant.likely@secretlab.ca>
	 <1339801070.9220.211.camel@pasglop> <20120616040028.C83513E0ACE@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 22:00 -0600, Grant Likely wrote:
> On Sat, 16 Jun 2012 08:57:50 +1000, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > On Fri, 2012-06-15 at 11:50 -0600, Grant Likely wrote:
> > > The pattern (np ? np->full_name : "<none>") is rather common in the
> > > kernel, but can also make for quite long lines.  This patch adds a new
> > > inline function, of_node_full_name() so that the test for a valid node
> > > pointer doesn't need to be open coded at all call sites.
> > 
> > s/of_node_full_name/of_node_path ?
> 
> It would be nicer to have the shorter name, but the data member is
> already named full_name, so I'd rather use the same for the function
> name (unless you argue strongly against, it's not something I'm going
> to fight about).

Nah, it's just that full_name was never a very good choice to begin
with ... Do as you wish. Renaming the data member might be a bit
annoying I can immagine :-)

Cheers,
Ben.


