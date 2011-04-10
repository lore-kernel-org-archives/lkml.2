Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab1DJUY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 16:24:27 -0400
Received: from fw.wantstofly.org ([80.101.37.227]:64606 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab1DJUYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 16:24:24 -0400
Date: Sun, 10 Apr 2011 22:27:16 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove non-MAINTAINERS email address references for
 Lennert Buytenhek.
Message-ID: <20110410202716.GK22881@wantstofly.org>
References: <20110410134504.GG22881@wantstofly.org>
 <20110410.132002.193717670.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110410.132002.193717670.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 10, 2011 at 01:20:02PM -0700, David Miller wrote:

> > This gets rid of all (obsolete as well as still valid) email addresses
> > for Lennert Buytenhek across the tree -- MAINTAINERS should be used for
> > obtaining a valid email address.
> > 
> > Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
> 
> Lennert, this is silly.
> 
> That email address acts as part of the identification of who you
> are, and is part of the copyright.

The problem is that half of them are out of date.  I at first sent a
patch to change them all over to buytenh@wantstofly.org, but then got:

	http://marc.info/?l=linux-kernel&m=129858453409012&w=2

which seemed sensible. :-/
