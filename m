Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2BAAHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 19:07:51 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51950 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2BAAHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 19:07:49 -0500
Date: Tue, 31 Jan 2012 17:07:42 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 00/25] irq_domain generalization and refinement
Message-ID: <20120201000742.GM22611@ponder.secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
 <20120131045344.GA27609@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120131045344.GA27609@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 08:53:44PM -0800, Olof Johansson wrote:
> On Fri, Jan 27, 2012 at 02:35:54PM -0700, Grant Likely wrote:
> > Hey everyone,
> > 
> > This patch series is ready for much wider consumption now.  I'd like
> > to get it into linux-next ASAP because there will be ARM board support
> > depending on it.  I'll wait a few days before I ask Stephen to pull
> > this in.
> > 
> > Stephen/Milton/Ben, any testing you can help with here would be
> > appreciated since you've got access to a wider variety of Power
> > machines than I do.
> 
> This series has been:
> 
> Tested-by: Olof Johansson <olof@lixom.net>
> 
> On powerpc/pasemi (it's the only one I still have easy access to).

Excellent, thanks Olof!

g.
