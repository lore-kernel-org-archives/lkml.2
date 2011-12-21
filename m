Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab1LUARN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:17:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65295 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab1LUARL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:17:11 -0500
Date: Tue, 20 Dec 2011 16:17:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: kosaki.motohiro@gmail.com
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Wilson <wilsons@start.ca>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm,mempolicy: mpol_equal() use bool
In-Reply-To: <1324421434-14342-1-git-send-email-kosaki.motohiro@gmail.com>
Message-ID: <alpine.DEB.2.00.1112201616300.29578@chino.kir.corp.google.com>
References: <1324421434-14342-1-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Dec 2011, kosaki.motohiro@gmail.com wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> mpol_equal() logically return boolean. then it should be used bool.
> This change slightly improve readability.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>

This code predates the introduction of the bool type to the kernel, so 
it's a good cleanup, thanks!
