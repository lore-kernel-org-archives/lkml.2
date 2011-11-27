Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab1K0GMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 01:12:24 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42294 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1K0GMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 01:12:21 -0500
Date: Sun, 27 Nov 2011 01:12:12 -0500 (EST)
Message-Id: <20111127.011212.195523927985734500.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 15/62] ide: remove the second argument of
 k[un]map_atomic()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322371662-26166-16-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
	<1322371662-26166-16-git-send-email-amwang@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 26 Nov 2011 22:12:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <amwang@redhat.com>
Date: Sun, 27 Nov 2011 13:26:55 +0800

> 
> Signed-off-by: Cong Wang <amwang@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
