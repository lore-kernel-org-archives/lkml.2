Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab1EXS3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:29:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34227 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab1EXS3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:29:54 -0400
Date: Tue, 24 May 2011 14:29:13 -0400 (EDT)
Message-Id: <20110524.142913.2084979139911365095.davem@davemloft.net>
To: jaxboe@fusionio.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, chris.mason@oracle.com
Subject: Re: [GIT PULL] Start of removal of legacy parallel interfaces for
 3.0
From: David Miller <davem@davemloft.net>
In-Reply-To: <4DDBF40E.7020003@fusionio.com>
References: <4DDBF40E.7020003@fusionio.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 24 May 2011 11:29:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jaxboe@fusionio.com>
Date: Tue, 24 May 2011 20:08:14 +0200

> With the 3.0 kernel approaching, now is a great time to get rid of some
> legacy bagage. And what better part to start with than the old IDE code.

We've already had this discussion a million times, we can't do this.
