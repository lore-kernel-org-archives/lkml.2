Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab0FMLY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 07:24:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48164 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab0FMLYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 07:24:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] Cleanup : change try_set_zone_oom with try_set_zonelist_oom
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>
In-Reply-To: <1276177124-3395-1-git-send-email-minchan.kim@gmail.com>
References: <1276177124-3395-1-git-send-email-minchan.kim@gmail.com>
Message-Id: <20100613163055.615A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 13 Jun 2010 20:24:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We have been used naming try_set_zone_oom and clear_zonelist_oom.
> The role of functions is to lock of zonelist for preventing parallel
> OOM. So clear_zonelist_oom makes sense but try_set_zone_oome is rather
> awkward and unmatched with clear_zonelist_oom.
> 
> Let's change it with try_set_zonelist_oom.

Ah, sure.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



