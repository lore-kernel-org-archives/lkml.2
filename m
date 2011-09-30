Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab1I3Acj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 20:32:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64496 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab1I3Ach (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 20:32:37 -0400
Date: Thu, 29 Sep 2011 18:32:14 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: David Miller <davem@davemloft.net>
Cc: david.daney@cavium.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/3] netdev/of/phy: MDIO bus multiplexer support.
Message-ID: <20110930003214.GB12606@ponder.secretlab.ca>
References: <1317166015-20714-1-git-send-email-david.daney@cavium.com>
 <20110929.163112.1523715692737597332.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929.163112.1523715692737597332.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 04:31:12PM -0400, David Miller wrote:
> From: David Daney <david.daney@cavium.com>
> Date: Tue, 27 Sep 2011 16:26:52 -0700
> 
> > v2: Update bindings to use "reg" and "mdio-parent-bus" insutead of
> >     "cell-index" and "parent-bus"
> 
> Grant, when the final version of this patch set is ready how do
> you want to handle merging it in?
> 
> I think it would be safe to merge this via your tree, since the
> changes made to existing network driver files are rather trivial and
> thus merge conflict friendly.

Your tree or mine, I'm happy either way.  Even if there were
conflicts, they would be trivial.

Sure, I'll take care of merging it when I see an ack from you.

> Actually, I feel like we've discussed this before :-)

:)

g.

