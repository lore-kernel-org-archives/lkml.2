Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab1KAI7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 04:59:36 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:52559 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab1KAI7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 04:59:35 -0400
Date: Tue, 1 Nov 2011 09:59:30 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 00/17] drop unused Kconfig symbols
Message-ID: <20111101085930.GF26898@axis.com>
References: <1319456255.2409.30.camel@x61.thuisdomein> <20111031224248.GB25411@sepie.suse.cz> <1320101716.14409.97.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320101716.14409.97.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 11:55:16PM +0100, Paul Bolle wrote:
> On Mon, 2011-10-31 at 23:42 +0100, Michal Marek wrote:
> > On Mon, Oct 24, 2011 at 01:37:35PM +0200, Paul Bolle wrote:
> > > 1) I've dropped five patches that were taken by the maintainers
> > > (blackfin, unicore32, tomoyo, m68k, and staging). cris got a NAK (for an
> > > invalid reason, but I guess I'll just try again after the v3.2 merge
> > > window closes).
> 
> Just today Jesper Nilsson basically dropped that NAK. I assume Jesper
> will try to carry the patch in (one of) their tree(s). Is that correct?

The patch that reintroduces the Kconfigs, yes, the one that removes them, no.

> Paul Bolle

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
