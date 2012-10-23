Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965266Ab2JWUPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:15:24 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:44086 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965254Ab2JWUPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:15:19 -0400
Message-ID: <1351023350.10322.21.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 173/193] net/mac80211: remove CONFIG_EXPERIMENTAL
From: Johannes Berg <johannes@sipsolutions.net>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Tue, 23 Oct 2012 22:15:50 +0200
In-Reply-To: <1351022666-6960-174-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	 <1351022666-6960-174-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 13:04 -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: "John W. Linville" <linville@tuxdriver.com>
> CC: Johannes Berg <johannes@sipsolutions.net>
> CC: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Presumably somebody is going to submit a git tree with the entire series
and you don't want me to pick up this piece, right?

johannes

