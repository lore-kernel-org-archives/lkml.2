Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab0CaM7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 08:59:14 -0400
Received: from ozlabs.org ([203.10.76.45]:40618 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348Ab0CaM7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 08:59:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next] module.h: add stub for is_module_percpu_address
Date: Wed, 31 Mar 2010 23:29:09 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
References: <20100330191834.f2009292.sfr@canb.auug.org.au> <4BB2358B.3090800@oracle.com>
In-Reply-To: <4BB2358B.3090800@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003312329.09722.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010 04:01:55 am Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build for CONFIG_MODULES not enabled by providing a stub
> for is_module_percpu_address().
> 
> kernel/lockdep.c:605: error: implicit declaration of function 'is_module_percpu_address'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
