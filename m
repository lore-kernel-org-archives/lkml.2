Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab2C2GwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:52:00 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35797 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab2C2Gvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:51:54 -0400
Date: Thu, 29 Mar 2012 02:51:46 -0400 (EDT)
Message-Id: <20120329.025146.655646952129988185.davem@davemloft.net>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: glommer@parallels.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [BUGFIX][PATCH 0/3] memcg: tcp memcontrol fixes.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F73FF9D.4090809@jp.fujitsu.com>
References: <4F73FF9D.4090809@jp.fujitsu.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 28 Mar 2012 23:51:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please post networking patches to netdev@vger.kernel.org, most of
the networking developers do not read linux-kernel and also
you need to post it to netdev to get it queued up in our networking
patchwork queue.

Thanks.
