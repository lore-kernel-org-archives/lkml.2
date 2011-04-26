Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab1DZC5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 22:57:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57549 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab1DZC5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 22:57:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [PATCH] use oom_killer_disabled in all oom pathes
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110426025429.GA11812@darkstar>
References: <20110426025429.GA11812@darkstar>
Message-Id: <20110426115902.F374.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 26 Apr 2011 11:57:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> oom_killer_disable should be a global switch, also fit for oom paths
> other than __alloc_pages_slowpath 
> 
> Here add it to mem_cgroup_handle_oom and pagefault_out_of_memory as well.

Can you please explain more? Why should? Now oom_killer_disabled is used
only hibernation path. so, Why pagefault and memcg allocation will be happen?




