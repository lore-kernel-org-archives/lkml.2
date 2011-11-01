Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1KAJqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 05:46:21 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:40688 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab1KAJqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:46:20 -0400
Subject: Re: [PATCH 00/17] drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
In-Reply-To: <20111101085930.GF26898@axis.com>
References: <1319456255.2409.30.camel@x61.thuisdomein>
	 <20111031224248.GB25411@sepie.suse.cz>
	 <1320101716.14409.97.camel@x61.thuisdomein>
	 <20111101085930.GF26898@axis.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Nov 2011 10:46:04 +0100
Message-ID: <1320140764.14409.135.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-01 at 09:59 +0100, Jesper Nilsson wrote:
> On Mon, Oct 31, 2011 at 11:55:16PM +0100, Paul Bolle wrote:
> > Just today Jesper Nilsson basically dropped that NAK. I assume Jesper
> > will try to carry the patch in (one of) their tree(s). Is that correct?
> 
> The patch that reintroduces the Kconfigs, yes, the one that removes them, no.

But yesterday you wrote:
On Fri, Oct 14, 2011 at 09:11:01PM +0200, Valdis.Kletnieks@vt.edu wrote:
[...]
> > (Personally, I'm tending towards unless it's going to be in linux-next within
> > the next month or so, pull the Kconfig variables out and the driver can re-add
> > them when it actually lands)
> 
> Ok, let's do it the right way and remove them now, and I can re-add
> them in the same tree.

So your plans have changed? It's OK with me if they change, of course,
but now I'm unsure what you intend to do.


Paul Bolle

