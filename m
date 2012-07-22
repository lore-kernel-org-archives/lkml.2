Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751089Ab2GVH3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 03:29:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60106 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab2GVH3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 03:29:36 -0400
Date: Sun, 22 Jul 2012 09:29:32 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
Message-ID: <20120722072932.GA1598@minipsycho.orion>
References: <20120722163408.6f2b74d31f05d45a88ed49de@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120722163408.6f2b74d31f05d45a88ed49de@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sun, Jul 22, 2012 at 08:34:08AM CEST, sfr@canb.auug.org.au wrote:
>Hi Dave,
>
>After merging the final tree, today's linux-next build (powerpc
>ppc44x_defconfig) failed like this:
>
>net/core/rtnetlink.c: In function 'rtnl_fill_ifinfo':
>net/core/rtnetlink.c:895:46: error: 'struct net_device' has no member named 'num_rx_queues'
>
>Caused by commit 76ff5cc91935 ("rtnl: allow to specify number of rx and
>tx queues on device creation").  This build does not have CONFIG_RPS set.
>
>I have reverted that commit for today.


I just sent a fix ccing you, Stephen.

Apologies, Jirka

>-- 
>Cheers,
>Stephen Rothwell                    sfr@canb.auug.org.au


