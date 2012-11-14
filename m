Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992460Ab2KNWbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:31:04 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35771 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992446Ab2KNWbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:31:02 -0500
Date: Wed, 14 Nov 2012 17:30:59 -0500 (EST)
Message-Id: <20121114.173059.2152995770988231211.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, walken@google.com, riel@redhat.com
Subject: Re: linux-next: build failure after merge of the final tree (akpm
 tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121114141847.fab752c2.akpm@linux-foundation.org>
References: <20121109150957.4f274fa7b3a75c9baaa1b7ff@canb.auug.org.au>
	<20121114141847.fab752c2.akpm@linux-foundation.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 14 Nov 2012 14:18:47 -0800

> s/colour/color/

The whole file uses the COLOUR spelling in it's macros, for
consistency I see no reason not to use the same spelling
for local variables.

Else, fix the whole file instead of leaving an inconsistent
mess around.

