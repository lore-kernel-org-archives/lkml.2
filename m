Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab1JZXku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 19:40:50 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43235 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab1JZXkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 19:40:49 -0400
Date: Wed, 26 Oct 2011 19:40:45 -0400 (EDT)
Message-Id: <20111026.194045.2019668159403582571.davem@davemloft.net>
To: kernel@teksavvy.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: asix usb network driver: nfg
From: David Miller <davem@davemloft.net>
In-Reply-To: <4EA89972.5060101@teksavvy.com>
References: <4EA89972.5060101@teksavvy.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 26 Oct 2011 16:40:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Lord <kernel@teksavvy.com>
Date: Wed, 26 Oct 2011 19:36:18 -0400

> So, the in-kernel asix driver seems badly broken for a lot of hardware,
> and the vendor driver also has a slight race somewhere that is cured
> by enabling debug logging.
> 
> Is there an asix driver maintainer, or anyone else with the time
> to step up and try to fix these issues?

The issues you speak of are well known for at least two years but
nobody wants to work on this.
