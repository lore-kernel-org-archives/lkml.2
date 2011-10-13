Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab1JMUSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:18:32 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50369 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab1JMUSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:18:31 -0400
Date: Thu, 13 Oct 2011 16:18:19 -0400 (EDT)
Message-Id: <20111013.161819.264553121596077263.davem@davemloft.net>
To: glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
        ebiederm@xmission.com, paul@paulmenage.org, gthelen@google.com,
        netdev@vger.kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        avagin@parallels.com, devel@openvz.org
Subject: Re: [PATCH v7 0/8] Request for inclusion: tcp memory buffers
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E9746B0.7030603@parallels.com>
References: <4E9744A6.5010101@parallels.com>
	<20111013.161221.1969725742975317077.davem@davemloft.net>
	<4E9746B0.7030603@parallels.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 13 Oct 2011 13:18:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Fri, 14 Oct 2011 00:14:40 +0400

> Are you happy, or at least willing to accept, an approach that keep
> things as they were with cgroups *compiled out*, or were you referring
> to not in use == compiled in, but with no users?

To me these are the same exact thing, because %99 of users will be running
a kernel with every feature turned on in the Kconfig.
