Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945925Ab2KNWdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:33:08 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35796 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423427Ab2KNWdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:33:06 -0500
Date: Wed, 14 Nov 2012 17:33:04 -0500 (EST)
Message-Id: <20121114.173304.405703188822325414.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        sparclinux@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] drivers/of: Constify device_node->name and
 ->path_component_name
From: David Miller <davem@davemloft.net>
In-Reply-To: <1352932107-14782-1-git-send-email-grant.likely@secretlab.ca>
References: <1352932107-14782-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You're making other changes here, such as the kstrdup() stuff,
seperate that into another patch.
