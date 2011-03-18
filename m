Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab1CRBL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 21:11:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54355
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755611Ab1CRBL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 21:11:26 -0400
Date: Thu, 17 Mar 2011 18:12:03 -0700 (PDT)
Message-Id: <20110317.181203.193711655.davem@davemloft.net>
To: roland@kernel.org
Cc: sean.hefty@intel.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, hal.rosenstock@gmail.com,
        eric.dumazet@gmail.com, tj@kernel.org, xiaosuo@gmail.com,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH] rdma/addr: Initialize ret to fix build warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTikB=ZQQG18sDbD2kfFMWdVuUqnzYWOf7KtuBKVc@mail.gmail.com>
References: <20110318100418.6556c92c.sfr@canb.auug.org.au>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25CCC10249@orsmsx501.amr.corp.intel.com>
	<AANLkTikB=ZQQG18sDbD2kfFMWdVuUqnzYWOf7KtuBKVc@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@kernel.org>
Date: Thu, 17 Mar 2011 16:56:27 -0700

> On Thu, Mar 17, 2011 at 4:35 PM, Hefty, Sean <sean.hefty@intel.com> wrote:
>> Commit b23dd4fe42b455af5c6e20966b7d6959fa8352ea (ipv4: Make output
>> route lookup return rtable directly) resulted in leaving
>> ret uninitialized, where it may later be returned.
> 
> Looks good to me, I'll merge this.

Thanks Roland.

Acked-by: David S. Miller <davem@davemloft.net>
