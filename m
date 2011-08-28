Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab1H1VM1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 17:12:27 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42549 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab1H1VMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 17:12:25 -0400
Date: Sun, 28 Aug 2011 17:12:07 -0400 (EDT)
Message-Id: <20110828.171207.2184384269364960247.davem@davemloft.net>
To: bfields@fieldses.org
Cc: torvalds@linux-foundation.org, ben@decadent.org.uk, neilb@suse.de,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] All Arch: remove linkage for sys_nfsservctl system call
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110826220311.GA18140@fieldses.org>
References: <20110808155538.GB904@fieldses.org>
	<20110808180658.GC29924@decadent.org.uk>
	<20110826220311.GA18140@fieldses.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 28 Aug 2011 14:12:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@fieldses.org>
Date: Fri, 26 Aug 2011 18:03:11 -0400

> From: NeilBrown <neilb@suse.de>
> 
> The nfsservctl system call is now gone, so we should remove all
> linkage for it.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> Signed-off-by: J. Bruce Fields <bfields@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
