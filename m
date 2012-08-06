Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab2HFUcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:32:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39032 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab2HFUcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:32:19 -0400
Date: Mon, 06 Aug 2012 13:32:18 -0700 (PDT)
Message-Id: <20120806.133218.784665611397147880.davem@davemloft.net>
To: segoon@openwall.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ip: fix error handling in ip_finish_output2()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120806135529.GA30699@albatros>
References: <20120806135529.GA30699@albatros>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasily Kulikov <segoon@openwall.com>
Date: Mon, 6 Aug 2012 17:55:29 +0400

> __neigh_create() returns either a pointer to struct neighbour or PTR_ERR().
> But the caller expects it to return either a pointer or NULL.  Replace
> the NULL check with IS_ERR() check.
> 
> The bug was introduced in a263b3093641fb1ec377582c90986a7fd0625184.
> 
> Signed-off-by: Vasily Kulikov <segoon@openwall.com>

Applied.

Please provide the proper commit log header line text when referencing
another commit, otherwise in trees where the SHA1 IDs are different,
nobody will be able to figure out what you are trying to refer to.

Thanks.
