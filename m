Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab1HHF4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 01:56:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48605 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1HHF4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 01:56:10 -0400
Date: Sun, 07 Aug 2011 22:55:46 -0700 (PDT)
Message-Id: <20110807.225546.356790607362959299.davem@davemloft.net>
To: thomas@m3y3r.de
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] n2_crypto: Fix a get/put_cpu() imbalance
From: David Miller <davem@davemloft.net>
In-Reply-To: <1312619188.5589.27.camel@localhost.localdomain>
References: <1312619188.5589.27.camel@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 07 Aug 2011 22:55:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>
Date: Sat, 06 Aug 2011 10:26:25 +0200

> From: Thomas Meyer <thomas@m3y3r.de>
> 
> Fix a get/put_cpu() imbalance in the error case when qp == NULL
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Acked-by: David S. Miller <davem@davemloft.net>
