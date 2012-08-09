Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685Ab2HIVtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:49:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60844 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759301Ab2HIVtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:49:05 -0400
Date: Thu, 09 Aug 2012 14:49:04 -0700 (PDT)
Message-Id: <20120809.144904.985433220461322851.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: makienko@ispras.ru, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH 03/13] ide: Potential null pointer dereference in
 ide_queue_pc_tail()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120809151342.2941f851@pyramind.ukuu.org.uk>
References: <1344520529-19164-1-git-send-email-makienko@ispras.ru>
	<20120809151342.2941f851@pyramind.ukuu.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Thu, 9 Aug 2012 15:13:42 +0100

> On Thu,  9 Aug 2012 17:55:20 +0400
> Marina Makienko <makienko@ispras.ru> wrote:
> 
>> The function blk_get_request() can return NULL in some cases. There are
>> checks on it if function is called with argumetns one of which is
>> GFP_ATOMIC/GFP_NOIO/etc. If system couldn't find request
>> blk_get_request() return NULL.
> 
> drivers/ide is obsolete and scheduled for removal. I'm not sure messing
> with it is remotely useful at this point ?

Agreed, I'm not applying this stuff.
