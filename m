Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154Ab1KIVPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 16:15:08 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40443 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709Ab1KIVPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 16:15:07 -0500
Date: Wed, 09 Nov 2011 16:15:03 -0500 (EST)
Message-Id: <20111109.161503.1008747144388695505.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jeffrey.t.kirsher@intel.com
Subject: Re: [PATCH] net: drivers/net/hippi/Kconfig should be sourced
From: David Miller <davem@davemloft.net>
In-Reply-To: <1320872916.27598.49.camel@x61.thuisdomein>
References: <1320784270.14409.404.camel@x61.thuisdomein>
	<20111109.154643.2008804116058722848.davem@davemloft.net>
	<1320872916.27598.49.camel@x61.thuisdomein>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 09 Nov 2011 13:15:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Wed, 09 Nov 2011 22:08:36 +0100

> Would it be better if I hadn't submitted this as a patch

Yes, because eventually someone who actually cared about the
situation would submit a properly tested patch.

If nobody else notices the problem, that's fine too, because it means
nobody else cares about whether HIPPI is missing from the build or
not.
