Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab1K0GNA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 01:13:00 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42313 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab1K0GM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 01:12:56 -0500
Date: Sun, 27 Nov 2011 01:12:52 -0500 (EST)
Message-Id: <20111127.011252.537231257613143449.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        ian.campbell@citrix.com, netdev@vger.kernel.org
Subject: Re: [PATCH 53/62] net: remove the second argument of
 k[un]map_atomic()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322371662-26166-54-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
	<1322371662-26166-54-git-send-email-amwang@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 26 Nov 2011 22:12:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <amwang@redhat.com>
Date: Sun, 27 Nov 2011 13:27:33 +0800

> Signed-off-by: Cong Wang <amwang@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
