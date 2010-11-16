Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab0KPUws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:52:48 -0500
Received: from smtp.outflux.net ([198.145.64.163]:32860 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185Ab0KPUwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:52:47 -0500
Date: Tue, 16 Nov 2010 12:51:42 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Hugh Dickins <hughd@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH] ipc: explicitly clear stack memory for shminfo
Message-ID: <20101116205142.GA13854@outflux.net>
References: <1289937508-19458-1-git-send-email-kees.cook@canonical.com>
 <20101116201620.GA11278@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116201620.GA11278@albatros>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vasiliy,

On Tue, Nov 16, 2010 at 11:16:20PM +0300, Vasiliy Kulikov wrote:
> Can you please clarify what fields (padding bytes?) are uninitialized
> here?  I see this struct shminfo definition:
> [snip]
> As I see all five fields are set anyway, no padding bytes here, correct?

You are correct, I was looking at shminfo64. Nevermind!

-Kees

-- 
Kees Cook
Ubuntu Security Team
