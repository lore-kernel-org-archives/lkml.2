Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2K1Q1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:27:18 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50143 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab2K1Q1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:27:16 -0500
Date: Wed, 28 Nov 2012 11:27:15 -0500 (EST)
Message-Id: <20121128.112715.652916144298491861.davem@davemloft.net>
To: mst@redhat.com
Cc: netdev@vger.kernel.org, jasowang@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: fix length for cross region descriptor
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121126155727.GA21716@redhat.com>
References: <20121126155727.GA21716@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 26 Nov 2012 17:57:27 +0200

> If a single descriptor crosses a region, the
> second chunk length should be decremented
> by size translated so far, instead it includes
> the full descriptor length.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied, thanks.
