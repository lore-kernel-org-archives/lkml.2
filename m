Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab2FFRh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:37:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37674 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272Ab2FFRhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:37:48 -0400
Date: Wed, 06 Jun 2012 10:37:47 -0700 (PDT)
Message-Id: <20120606.103747.2047367637475518048.davem@davemloft.net>
To: christian.dietrich@informatik.uni-erlangen.de
Cc: joe@perches.com, sshtylyov@mvista.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, vamos-dev@lists.cs.fau.de
Subject: Re: [PATCH] ide: icside.c: fix printk format string compile warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <86zk8i2b90.fsf@gandalf.zerties.org>
References: <86hauw7jee.fsf_-_@gandalf.zerties.org>
	<1338672377.24148.6.camel@joe2Laptop>
	<86zk8i2b90.fsf@gandalf.zerties.org>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
Date: Tue, 05 Jun 2012 14:28:59 +0200

> Use correct format string parameter for the peak datarate, and prevent
> uninitialized use of cycle_time.
> 
> Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>

Applied.
