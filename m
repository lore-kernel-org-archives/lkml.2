Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab2BVT53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 14:57:29 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:44640 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab2BVT52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 14:57:28 -0500
Date: Wed, 22 Feb 2012 14:57:22 -0500 (EST)
Message-Id: <20120222.145722.742265714781636882.davem@davemloft.net>
To: dave@gnu.org
Cc: mcarlson@broadcom.com, mchan@broadcom.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] tg3: remove IRQF_SAMPLE_RANDOM flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329916014.2586.2.camel@offbook>
References: <1329916014.2586.2.camel@offbook>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 22 Feb 2012 11:57:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>
Date: Wed, 22 Feb 2012 14:06:54 +0100

> From: Davidlohr Bueso <dave@gnu.org>
> 
> This driver is the last user of the IRQF_SAMPLE_RANDOM flag for net drivers, and since add_*_randomness
> interfaces have now deprecated the flag as a source of external noise, we can remove it.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>

Applied.
