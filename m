Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab1JSVJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:09:42 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39513 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab1JSVJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:09:41 -0400
Date: Wed, 19 Oct 2011 17:09:16 -0400 (EDT)
Message-Id: <20111019.170916.1029139785670746405.davem@davemloft.net>
To: glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
        ebiederm@xmission.com, paul@paulmenage.org, gthelen@google.com,
        netdev@vger.kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        avagin@parallels.com, devel@openvz.org
Subject: Re: [PATCH v7 0/8] Request for inclusion: tcp memory buffers
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E983177.5000005@parallels.com>
References: <4E9746B0.7030603@parallels.com>
	<20111013.161819.264553121596077263.davem@davemloft.net>
	<4E983177.5000005@parallels.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 19 Oct 2011 14:09:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Fri, 14 Oct 2011 16:56:23 +0400

> Please let me know what do you think of the following patch. It is
> still crude, and applies on top of what I had, for simplicity. I can
> of course rework all the series for the next submission. The main idea
> is:

Thanks, I promise to look at this soon.
