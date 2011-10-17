Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1JQOtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:49:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:35339 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab1JQOtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:49:49 -0400
Subject: Re: [PATCH v2 0/3] netdev/of/phy: MDIO bus multiplexer support.
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20110930003214.GB12606@ponder.secretlab.ca>
Date: Mon, 17 Oct 2011 09:48:47 -0500
Cc: David Miller <davem@davemloft.net>, david.daney@cavium.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <C81814FF-4E56-4B28-8043-F874EE1D6B51@kernel.crashing.org>
References: <1317166015-20714-1-git-send-email-david.daney@cavium.com> <20110929.163112.1523715692737597332.davem@davemloft.net> <20110930003214.GB12606@ponder.secretlab.ca>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 29, 2011, at 7:32 PM, Grant Likely wrote:

> On Thu, Sep 29, 2011 at 04:31:12PM -0400, David Miller wrote:
>> From: David Daney <david.daney@cavium.com>
>> Date: Tue, 27 Sep 2011 16:26:52 -0700
>> 
>>> v2: Update bindings to use "reg" and "mdio-parent-bus" insutead of
>>>    "cell-index" and "parent-bus"
>> 
>> Grant, when the final version of this patch set is ready how do
>> you want to handle merging it in?
>> 
>> I think it would be safe to merge this via your tree, since the
>> changes made to existing network driver files are rather trivial and
>> thus merge conflict friendly.
> 
> Your tree or mine, I'm happy either way.  Even if there were
> conflicts, they would be trivial.
> 
> Sure, I'll take care of merging it when I see an ack from you.
> 
>> Actually, I feel like we've discussed this before :-)
> 
> :)
> 
> g.

Any updates to these patches?

- k
