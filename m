Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab1EIHpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 03:45:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43541 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab1EIHpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 03:45:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH 4/8] mm: make gather_stats() type-safe and remove forward declaration
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1303947349-3620-5-git-send-email-wilsons@start.ca>
References: <1303947349-3620-1-git-send-email-wilsons@start.ca> <1303947349-3620-5-git-send-email-wilsons@start.ca>
Message-Id: <20110509164723.165B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon,  9 May 2011 16:45:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Improve the prototype of gather_stats() to take a struct numa_maps as
> argument instead of a generic void *.  Update all callers to make the
> required type explicit.
> 
> Since gather_stats() is not needed before its definition and is
> scheduled to be moved out of mempolicy.c the declaration is removed as
> well.
> 
> Signed-off-by: Stephen Wilson <wilsons@start.ca>

Looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



