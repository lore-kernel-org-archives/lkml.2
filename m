Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab1C0UlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 16:41:16 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29644 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab1C0UlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 16:41:15 -0400
Date: Sun, 27 Mar 2011 22:41:15 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ipc: fix util.c kernel-doc warnings
In-Reply-To: <20110326132741.c7ccbe87.randy.dunlap@oracle.com>
Message-ID: <alpine.LNX.2.00.1103272240480.6111@swampdragon.chaosbits.net>
References: <20110326132741.c7ccbe87.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Mar 2011, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix ipc/util.c kernel-doc warnings:
> 
> Warning(ipc/util.c:336): No description found for parameter 'ns'
> Warning(ipc/util.c:620): No description found for parameter 'ns'
> Warning(ipc/util.c:790): No description found for parameter 'ns'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

