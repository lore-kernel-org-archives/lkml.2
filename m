Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab2GSBnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:43:49 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:55574 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab2GSBns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:43:48 -0400
Date: Thu, 19 Jul 2012 10:43:42 +0900
From: Simon Horman <horms@verge.net.au>
To: Claudiu Ghioc <claudiughioc@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        wensong@linux-vs.org, ja@ssi.bg, pablo@netfilter.org, kaber@trash.net,
        claudiu.ghioc@gmail.com, daniel.baluta@gmail.com
Subject: Re: [PATCH v2] ipvs: fixed sparse warning
Message-ID: <20120719014341.GI29894@verge.net.au>
References: <1342602622-2728-1-git-send-email-claudiu.ghioc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342602622-2728-1-git-send-email-claudiu.ghioc@gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 12:10:22PM +0300, Claudiu Ghioc wrote:
> Removed the following sparse warnings, wether CONFIG_SYSCTL
> is defined or not:
> *       warning: symbol 'ip_vs_control_net_init_sysctl' was not
> 	declared. Should it be static?
> *       warning: symbol 'ip_vs_control_net_cleanup_sysctl' was
> 	not declared. Should it be static?
> 
> Signed-off-by: Claudiu Ghioc <claudiu.ghioc@gmail.com>

Thanks, I have queued this up for 3.6.
