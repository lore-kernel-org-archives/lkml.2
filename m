Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab1JXViZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 17:38:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45238 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab1JXViY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 17:38:24 -0400
Date: Mon, 24 Oct 2011 17:35:36 -0400 (EDT)
Message-Id: <20111024.173536.776095567988184340.davem@davemloft.net>
To: fbl@redhat.com
Cc: netdev@vger.kernel.org, dpmcgee@gmail.com, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TCP: remove TCP_DEBUG
From: David Miller <davem@davemloft.net>
In-Reply-To: <1319480110-20361-1-git-send-email-fbl@redhat.com>
References: <CAEik5nPciVMwOE-hC+oPP1gMEvRzbhFwAZHKNQnHEc0YOUXuWA@mail.gmail.com>
	<1319480110-20361-1-git-send-email-fbl@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 24 Oct 2011 14:35:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Flavio Leitner <fbl@redhat.com>
Date: Mon, 24 Oct 2011 16:15:10 -0200

> It was enabled by default and the messages guarded
> by the define are useful.
> 
> Signed-off-by: Flavio Leitner <fbl@redhat.com>

Applied, thanks Flavio.
