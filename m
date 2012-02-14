Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760362Ab2BNTnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 14:43:23 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:48535 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123Ab2BNTnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 14:43:20 -0500
Date: Tue, 14 Feb 2012 14:42:07 -0500 (EST)
Message-Id: <20120214.144207.182139685565921136.davem@davemloft.net>
To: dhowells@redhat.com
Cc: axel.lin@gmail.com, linux-kernel@vger.kernel.org, zohar@us.ibm.com,
        thomas@m3y3r.de, anton@samba.org, netdev@vger.kernel.org
Subject: Re: [PATCH] RxRPC: Fix kcalloc parameters swapped
From: David Miller <davem@davemloft.net>
In-Reply-To: <18099.1329235408@redhat.com>
References: <1329200354.3806.1.camel@phoenix>
	<18099.1329235408@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 14 Feb 2012 11:42:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Tue, 14 Feb 2012 16:03:28 +0000

> Axel Lin <axel.lin@gmail.com> wrote:
> 
>> The first parameter should be "number of elements" and the second parameter
>> should be "element size".
>> 
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Not that it matters, I think, but let's be consistent...
> 
> Acked-by: David Howells <dhowells@redhat.com>

Applied.
