Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2HMCbA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 22:31:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56016 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab2HMCa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 22:30:59 -0400
Date: Mon, 13 Aug 2012 03:30:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: netdev@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [flame^Wreview] net: netprio_cgroup: rework update socket logic
Message-ID: <20120813023055.GA23464@ZenIV.linux.org.uk>
References: <20120813015348.GZ23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120813015348.GZ23464@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 02:53:48AM +0100, Al Viro wrote:
> 	if (old_priomap)
> 		memcpy(new_priomap->priomap, old_priomap,
					     ^^^^^^^^^^^
					     old_priomap->priomap,
that is.
