Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab2B2Uiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:38:50 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33526 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2B2Uit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:38:49 -0500
Date: Wed, 29 Feb 2012 15:36:33 -0500 (EST)
Message-Id: <20120229.153633.249570825230282737.davem@davemloft.net>
To: ddaney.cavm@gmail.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com
Subject: Re: [PATCH v6 2/2] of: Make of_find_node_by_path() traverse
 /aliases for relative paths.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330543264-18103-3-git-send-email-ddaney.cavm@gmail.com>
References: <1330543264-18103-1-git-send-email-ddaney.cavm@gmail.com>
	<1330543264-18103-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 29 Feb 2012 12:36:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney.cavm@gmail.com>
Date: Wed, 29 Feb 2012 11:21:04 -0800

> Currently all paths passed to of_find_node_by_path() must begin with a
> '/', indicating a full path to the desired node.
> 
> Augment the look-up code so that if a path does *not* begin with '/',
> the path is used as the name of an /aliases property.  The value of
> this alias is then used as the full node path to be found.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

But as the caller you sure as hell know whether you have a "/"
prefixed name or not.

Why complicate an incredibly well designed and simple function for
something you can create another interface for?
