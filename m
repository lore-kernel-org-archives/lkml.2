Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab2JCGGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 02:06:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54245 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab2JCGGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 02:06:20 -0400
Date: Wed, 03 Oct 2012 02:06:19 -0400 (EDT)
Message-Id: <20121003.020619.772556428995851933.davem@davemloft.net>
To: jeff@garzik.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au
Subject: Re: [PATCH v0] Add SHA-3 hash algorithm
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121003054542.GA2416@havoc.gtf.org>
References: <20121003054542.GA2416@havoc.gtf.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Wed, 3 Oct 2012 01:45:42 -0400

> 1) tcrypt setup blatantly wrong.  What is the best setup here?  Define a
> separate entry for each digest length?  Is there some special string
> descriptor format that is desired, like "sha3-256" or "sha3(256)"?

Good question.  The base name should probably be something without
dashes.  Maybe "sha3_256", but yeah "sha3256" would look rediculous.
