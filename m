Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab1CXGZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 02:25:21 -0400
Received: from linux-sh.org ([111.68.239.195]:49718 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab1CXGZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 02:25:19 -0400
Date: Thu, 24 Mar 2011 15:25:12 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH] sh: Fix build alloc_thread_info_node function
Message-ID: <20110324062511.GA18002@linux-sh.org>
References: <1300945660-8323-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300945660-8323-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 02:47:40PM +0900, Nobuhiro Iwamatsu wrote:
> By commit b6a84016bd2598e35ead635147fa53619982648d,
> alloc_thread_info was replaced by alloc_thread_info_node.
> However, the change of the function name and the addition of the argument
> were incomplete.
> 
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
> CC: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks.
