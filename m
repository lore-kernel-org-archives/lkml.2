Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab0GTXCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 19:02:05 -0400
Received: from tundra.namei.org ([65.99.196.166]:50424 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927Ab0GTXCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 19:02:02 -0400
Date: Wed, 21 Jul 2010 09:02:01 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <kees.cook@canonical.com>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Yama: turn process ancestry check into function
In-Reply-To: <20100713173339.GA6104@outflux.net>
Message-ID: <alpine.LRH.2.00.1007210901490.22161@tundra.namei.org>
References: <20100713173339.GA6104@outflux.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010, Kees Cook wrote:

> This cleans up the ancestry check by separating it out into its own
> function, which makes the code a bit more readable.  Additionally, it
> now checks for and uses the thread group leader since otherwise we may
> end up missing potential matches on attaches to threads.
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
