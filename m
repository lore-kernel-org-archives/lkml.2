Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab2AUIdP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 03:33:15 -0500
Received: from seven.medozas.de ([188.40.89.202]:41935 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab2AUIdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 03:33:14 -0500
Date: Sat, 21 Jan 2012 09:33:11 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Richard Weinberger <richard@nod.at>
cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: Merge ipt_LOG and ip6t_LOG
In-Reply-To: <1327103248-18918-1-git-send-email-richard@nod.at>
Message-ID: <alpine.LNX.2.01.1201210932390.17879@frira.zrqbmnf.qr>
References: <1327103248-18918-1-git-send-email-richard@nod.at>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 2012-01-21 00:47, Richard Weinberger wrote:

>Hi!
>
>These two patches merge ipt_LOG and ip6t_LOG.
>
>I'm not really happy with the iptables patch.
>As it depends on xt_log.h iptables will not compile with old 
>kernel headers.
>Any idea how to deal with this?

iptables always has its own copy of the header set, so there is not 
going to be a problem.
