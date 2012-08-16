Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab2HPEkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 00:40:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55270 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab2HPEkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 00:40:07 -0400
Date: Wed, 15 Aug 2012 21:40:02 -0700 (PDT)
Message-Id: <20120815.214002.952465247315588940.davem@davemloft.net>
To: minipli@googlemail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] net: info leaks and other bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1345066317-22512-1-git-send-email-minipli@googlemail.com>
References: <1345066317-22512-1-git-send-email-minipli@googlemail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>
Date: Wed, 15 Aug 2012 23:31:43 +0200

> this series fixes quite a bunch of info leaks under net/. There is also
> one NULL pointer deref fix ("dccp: check ccid before..") that could be
> abused for privilege escalation.
> 
> The info leak fixes might be material for stable, too. But I leave the
> decision up to you.
> 
> On request, test code for all (but one) of the issues can be provided.

All applied and queued up for -stable, thanks a lot.
