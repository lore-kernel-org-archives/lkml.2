Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab2BQByq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:54:46 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:45570 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab2BQByp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:54:45 -0500
Date: Thu, 16 Feb 2012 20:52:31 -0500 (EST)
Message-Id: <20120216.205231.945122823725765709.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, herbert@gondor.hengli.com.au
Subject: Re: [21/28] crypto: sha512 - Avoid stack bloat on i386
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120217005536.880797019@linuxfoundation.org>
References: <20120217005609.GA17081@kroah.com>
	<20120217005536.880797019@linuxfoundation.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 16 Feb 2012 17:52:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Thu, 16 Feb 2012 16:55:55 -0800

> 3.2-stable review patch.  If anyone has any objections, please let me know.

This causes a stack usage regression on sparc that Herbert
is in the middle of merging a fix for into Linus's tree.
