Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019Ab1EMUNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 16:13:23 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48755 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab1EMUNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 16:13:21 -0400
Date: Fri, 13 May 2011 16:08:44 -0400 (EDT)
Message-Id: <20110513.160844.521810878044428093.davem@davemloft.net>
To: segoon@openwall.com
Cc: solar@openwall.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        peak@argo.troja.mff.cuni.cz, kees.cook@canonical.com,
        dan.j.rosenberg@gmail.com, eugene@redhat.com, nelhage@ksplice.com,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH v3] net: ipv4: add IPPROTO_ICMP socket kind
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110513200100.GA3875@albatros>
References: <20110510.121550.112583080.davem@davemloft.net>
	<20110513200100.GA3875@albatros>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 May 2011 13:08:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>
Date: Sat, 14 May 2011 00:01:00 +0400

> This patch adds IPPROTO_ICMP socket kind.

Applied, thanks for following through on all the review feedback.

