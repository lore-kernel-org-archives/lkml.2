Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab3AGDTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 22:19:23 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:61054 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3AGDTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 22:19:22 -0500
Date: Mon, 7 Jan 2013 04:19:18 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/wireless/mwl8k.c: avoid use-after-free
Message-ID: <20130107031918.GA27530@wantstofly.org>
References: <1357522042-39255-1-git-send-email-nickolai@csail.mit.edu>
 <20130107024827.GZ27530@wantstofly.org>
 <CADGQE7EYbYqSkZZJfg-b0sF4w7GPrsGtXk+VBdWZ12Z7Xv7tcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADGQE7EYbYqSkZZJfg-b0sF4w7GPrsGtXk+VBdWZ12Z7Xv7tcg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 10:02:14PM -0500, Nickolai Zeldovich wrote:

> > Good catch, but the patch would be better titled "mwl8k.c: avoid
> > having a working driver", as the station_id return code _is_ needed
> > by the caller in case of success.
> 
> I'm not quite sure what you mean -- is there something subtle going on
> here?  I believe my patch preserves the semantics of the original
> code: it returns the value of p->station_id if mwl8k_post_cmd()
> returned 0, but it just does so by reading p->station_id first before
> calling kfree(cmd).

Oops!  You're right.  Sorry about that.

/me goes to order some crow for dinner
