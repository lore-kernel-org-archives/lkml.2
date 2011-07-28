Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab1G1Xyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:54:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54790 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303Ab1G1Xyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:54:36 -0400
Date: Fri, 29 Jul 2011 01:54:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Andi Kleen <andi@firstfloor.org>, pablo@netfilter.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: Re: [PATCH] [59/99] netfilter: IPv6: fix DSCP mangle code
Message-ID: <20110728235434.GL8006@one.firstfloor.org>
References: <20110727247.325703029@firstfloor.org> <20110727214858.5FECE2403FF@tassilo.jf.intel.com> <1311817873.2707.5.camel@nausicaa>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311817873.2707.5.camel@nausicaa>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 10:51:13AM +0900, Fernando Luis Vazquez Cao wrote:
> Hi Andi,
> 
> Thank you for picking up patches 58/99 (netfilter: IPv6: initialize TOS
> field in REJECT target module) and 59/99 (netfilter: IPv6: fix DSCP
> mangle code).
> 
> I would really appreciate it if you could also apply two IGMP snooping
> fixes that are already upstream, without them multicast bridging does
> not work at all in certain configurations. I will be replying to this
> email with the patches.

Added thanks.
-Andi
