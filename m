Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab1FQTCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 15:02:47 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49866 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab1FQTCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 15:02:43 -0400
Date: Fri, 17 Jun 2011 15:01:35 -0400 (EDT)
Message-Id: <20110617.150135.1664074829629603538.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-06-17
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110617173613.GC6820@tuxdriver.com>
References: <20110617173613.GC6820@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 17 Jun 2011 12:01:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 17 Jun 2011 13:36:14 -0400

> Here is a batch of fixes intended for 3.0.  Included are a regression
> for mwl8k which caused CCMP encryption to fail on that device, and an
> mwifiex fix for a null pointer dereference.  Also included is a batch
> of Bluetooth fixes from Gustavo, including a regression fix for BT 1.1
> devices, a fix for shutdown of SCO devices, a fix for an information
> leak, and a silly error-checking fix that I thought was worth including
> to prevent misinterpreting bad data as device command options.
> 
> Please let me know if there are problems!

Pulled, thanks John.
