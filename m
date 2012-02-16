Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab2BPDNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 22:13:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:44005 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066Ab2BPDNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 22:13:15 -0500
Message-ID: <1329361982.3772.44.camel@pasglop>
Subject: Re: [PATCH] of: Only compile OF_DYNAMIC on PowerPC pseries and
 iseries
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>,
        Rob Herring <rob.herring@calxeda.com>
Date: Thu, 16 Feb 2012 14:13:02 +1100
In-Reply-To: <1329240330-3539-1-git-send-email-grant.likely@secretlab.ca>
References: <1329240330-3539-1-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 10:25 -0700, Grant Likely wrote:
> Only two architectures use the OF node reference counting and reclaim bits.
> There is no need to compile it for the rest of the PowerPC platforms or for
> any of the other architectures.  This patch makes iseries and pseries
> select CONFIG_OF_DYNAMIC, and makes it default to off for everything else.
> 
> It is still safe to turn on CONFIG_OF_DYNAMIC on all architectures, it just
> isn't necessary.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: "David S. Miller" <davem@davemloft.net>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
Ben.


