Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab2HNHcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 03:32:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32910 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab2HNHcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 03:32:42 -0400
Message-ID: <5029FF15.4030903@gmail.com>
Date: Tue, 14 Aug 2012 11:32:37 +0400
From: Denis <yefremov.denis@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: Re: [PATCH] [NETFILTER] bridge: rcu_deref outside read-lock section
References: <1344898062-23633-1-git-send-email-yefremov.denis@gmail.com> <20120813163641.69a8388a@nehalam.linuxnetplumber.net>
In-Reply-To: <20120813163641.69a8388a@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.08.2012 3:36, Stephen Hemminger wrote:
> Why not just move the rcu_read_lock() in br_dev_xmit earlier? 

I don't know the semantics of this code, so it's difficult for me to
choose the appropriate place. I thought that the callers
of br_nf_pre_routing_finish_bridge_slow function are limited to
br_dev_xmit and we can modify header without problems.
Anyway, I will send another version of the patch.

