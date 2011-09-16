Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141Ab1IPAvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 20:51:15 -0400
Received: from tundra.namei.org ([65.99.196.166]:34451 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab1IPAvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 20:51:14 -0400
Date: Fri, 16 Sep 2011 10:51:06 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (security
 tree related)
In-Reply-To: <1316124231.3345.29.camel@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1109161050430.31572@tundra.namei.org>
References: <20110915170715.a380a5be954efc5891386ee3@canb.auug.org.au> <1316124231.3345.29.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011, Mimi Zohar wrote:

> Thanks Stephen.  James, assuming that the patch needs to be made
> available from the security tree, it's available from:
> 
> The following changes since commit 8de6ac7f58a22fdab399fbe97763e465ea49c735:
> 
>   Merge branch 'next-evm' of git://github.com/mzohar/linux-evm into next (2011-09-15 09:53:38 +1000)
> 
> are available in the git repository at:
> 
>   git://github.com/mzohar/linux-evm.git next-for-james
> 
> Stephen Rothwell (1):
>       encrypted-keys: IS_ERR need include/err.h
> 
>  security/keys/encrypted-keys/masterkey_trusted.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Pulled, thanks.

-- 
James Morris
<jmorris@namei.org>
