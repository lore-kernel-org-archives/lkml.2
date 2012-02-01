Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab2BATka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:40:30 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33731 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab2BATk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:40:28 -0500
Date: Wed, 01 Feb 2012 14:40:10 -0500 (EST)
Message-Id: <20120201.144010.700234218609686826.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: t.sailer@alumni.ethz.ch, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/16] hamradio: fix incompatible pointer in module
 parameter
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327960820-11867-15-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
	<1327960820-11867-15-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 01 Feb 2012 11:40:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Mon, 30 Jan 2012 23:00:18 +0100

> Fixed 'warning: return from incompatible pointer type' related
> to module parameters.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied, thanks.
