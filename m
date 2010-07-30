Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252Ab0G3R3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:29:34 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:58063 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759228Ab0G3R3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:29:31 -0400
Date: Fri, 30 Jul 2010 19:28:33 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Tejun Heo <tj@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vamos-dev@i4.informatik.uni-erlangen.de" 
	<vamos-dev@i4.informatik.uni-erlangen.de>
Subject: Re: [PATCH 09/11] Removing dead ETRAX_NETWORK_RED_ON_NO_CONNECTION
Message-ID: <20100730172833.GG9784@axis.com>
References: <cover.1279110894.git.siccegge@cs.fau.de> <d8e76e2563bb1ced76b1629859a7dc02e8f2523c.1279110895.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8e76e2563bb1ced76b1629859a7dc02e8f2523c.1279110895.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 02:41:20PM +0200, Christoph Egger wrote:
> ETRAX_NETWORK_RED_ON_NO_CONNECTION doesn't exist in Kconfig, therefore
> removing all references for it from the source code.

> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
