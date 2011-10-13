Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1JMUid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:38:33 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37321 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1JMUid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:38:33 -0400
Date: Thu, 13 Oct 2011 16:37:08 -0400 (EDT)
Message-Id: <20111013.163708.1319779926961023813.davem@davemloft.net>
To: rientjes@google.com
Cc: ian.campbell@citrix.com, linux-kernel@vger.kernel.org, hch@infradead.org,
        jaxboe@fusionio.com, linux-mm@kvack.org
Subject: Re: [PATCH] mm: add a "struct page_frag" type containing a page,
 offset and length
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.1110131327470.24853@chino.kir.corp.google.com>
References: <1318500176-10728-1-git-send-email-ian.campbell@citrix.com>
	<alpine.DEB.2.00.1110131327470.24853@chino.kir.corp.google.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 13 Oct 2011 13:37:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>
Date: Thu, 13 Oct 2011 13:33:45 -0700 (PDT)

> On Thu, 13 Oct 2011, Ian Campbell wrote:
> 
>> A few network drivers currently use skb_frag_struct for this purpose but I have
>> patches which add additional fields and semantics there which these other uses
>> do not want.
>> 
> 
> Is this patch a part of a larger series that actually uses 
> struct page_frag?  Probably a good idea to post them so we know it doesn't 
> just lie there dormant.

See:

http://patchwork.ozlabs.org/patch/118693/
http://patchwork.ozlabs.org/patch/118694/
http://patchwork.ozlabs.org/patch/118695/
http://patchwork.ozlabs.org/patch/118700/
http://patchwork.ozlabs.org/patch/118696/
http://patchwork.ozlabs.org/patch/118699/

This is a replacement for patch #1 in that series.
