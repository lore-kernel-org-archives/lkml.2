Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab2C0Val (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 17:30:41 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45921 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab2C0Vaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 17:30:39 -0400
Date: Tue, 27 Mar 2012 17:30:26 -0400 (EDT)
Message-Id: <20120327.173026.1921458003009946618.davem@davemloft.net>
To: acme@ghostprotocols.net
Cc: mingo@kernel.org, eranian@google.com, dumitru.sorin87@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] perf: Validate address in
 symbol__inc_addr_samples().
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120327141523.GA6931@infradead.org>
References: <20120325.162808.1311176271259118121.davem@davemloft.net>
	<20120327141523.GA6931@infradead.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 27 Mar 2012 14:30:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Tue, 27 Mar 2012 11:15:24 -0300

> Em Sun, Mar 25, 2012 at 04:28:08PM -0400, David Miller escreveu:
>> If addr < sym->start then we are going to access past the end of the
>> h->addr[] array, since the offset calculated will be huge.
>> 
>> Trigger an assertion instead of randomly scribbling memory when this
>> situation occurs.
> 
> I'm applying this one instead, please check if you have any concerns
> with this approach:

No objections.
