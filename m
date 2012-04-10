Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab2DJSnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:43:49 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46847 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758567Ab2DJSnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:43:47 -0400
Date: Tue, 10 Apr 2012 14:41:36 -0400 (EDT)
Message-Id: <20120410.144136.1777978593334560368.davem@davemloft.net>
To: key@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        rcj@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 14/17] powerpc: crypto: nx driver code supporting nx
 encryption
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334070657.16827.29.camel@key-ThinkPad-W510>
References: <1334070249.16827.1.camel@key-ThinkPad-W510>
	<1334070657.16827.29.camel@key-ThinkPad-W510>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 10 Apr 2012 11:41:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Yoder <key@linux.vnet.ibm.com>
Date: Tue, 10 Apr 2012 10:10:57 -0500

> These routines add the base device driver code supporting the Power7+
> in-Nest encryption accelerator (nx) device.
> 
> Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>

This patch should be earlier in the series, so it can
appear before the drivers which use the helper routines
in here.
