Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab2DYSYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:24:53 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52780 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab2DYSYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:24:52 -0400
Date: Wed, 25 Apr 2012 14:24:43 -0400 (EDT)
Message-Id: <20120425.142443.127806422826680167.davem@davemloft.net>
To: bpoirier@suse.de
Cc: chessman@tux.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tlan: add cast needed for proper 64 bit operation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1335365360-4891-1-git-send-email-bpoirier@suse.de>
References: <1335365360-4891-1-git-send-email-bpoirier@suse.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 25 Apr 2012 11:24:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Poirier <bpoirier@suse.de>
Date: Wed, 25 Apr 2012 10:49:20 -0400

> Changes this beauty into a statement that actually has an effect on amd64.
> 
> Tested-by: Per Jessen <per@opensuse.org>
> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>

Applied, thanks.
