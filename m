Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab1CFLjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 06:39:09 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48087 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab1CFLjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 06:39:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: bookjovi@gmail.com
Subject: Re: [PATCH 2/2] proc: fix some wrong error code usage
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1299104422-2620-1-git-send-email-bookjovi@gmail.com>
References: <1299104422-2620-1-git-send-email-bookjovi@gmail.com>
Message-Id: <20110306203830.6CD2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun,  6 Mar 2011 20:39:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jovi Zhang <bookjovi@gmail.com>
> 
> [root@wei 1]# cat /proc/1/mem
> cat: /proc/1/mem: No such process
> 
> error code -ESRCH is wrong in this situation
> 
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>

Looks fine.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



