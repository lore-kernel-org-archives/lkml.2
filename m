Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab2E3UgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:36:18 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41632 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab2E3UgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:36:17 -0400
Date: Wed, 30 May 2012 16:36:05 -0400 (EDT)
Message-Id: <20120530.163605.43003785250138845.davem@davemloft.net>
To: mst@redhat.com
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH repost] virtio-net: remove useless disable on freeze
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120530142128.GA31299@redhat.com>
References: <20120530142128.GA31299@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 30 May 2012 13:36:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 30 May 2012 17:21:29 +0300

> disable_cb is just an optimization: it
> can not guarantee that there are no callbacks.
> In particular it doesn't have any effect when
> event index is on.
> 
> Instead, detach, napi disable and reset on freeze ensure we don't run
> concurrently with a callback.
> 
> Remove the useless calls so we get same behaviour
> with and without event index.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> Reposting a patch that seems to have fallen through cracks.

It seems to not make it to the lists and get properly picked up
by patchwork.

In any event, I've applied this, thanks.
