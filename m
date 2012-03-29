Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781Ab2C2B0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 21:26:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33295 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758702Ab2C2BZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 21:25:36 -0400
Date: Wed, 28 Mar 2012 21:25:24 -0400 (EDT)
Message-Id: <20120328.212524.1423286973836820167.davem@davemloft.net>
To: keithp@keithp.com
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@intel.com
Subject: Re: [PATCH] Revert "Bluetooth: Always enable management interface"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332983958-2734-1-git-send-email-keithp@keithp.com>
References: <1332983958-2734-1-git-send-email-keithp@keithp.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 28 Mar 2012 18:25:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Packard <keithp@keithp.com>
Date: Wed, 28 Mar 2012 18:19:18 -0700

> This reverts commit 4b95a24ce12c4545fd7d2e3075841dc3119d1d71.
> 
> My USB bluetooth device does not show up with this patch in place.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>

Bluetooth folks please look over this, thanks.
