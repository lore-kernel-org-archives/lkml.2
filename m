Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0IMTWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:22:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59674
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936Ab0IMTWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:22:13 -0400
Date: Mon, 13 Sep 2010 12:22:31 -0700 (PDT)
Message-Id: <20100913.122231.183042924.davem@davemloft.net>
To: tim.gardner@canonical.com
Cc: stable@kernel.org, heiko.bauke@snafu.de, linux-kernel@vger.kernel.org,
        romieu@fr.zoreil.com, timo.teras@iki.fi
Subject: Re: Realtek Ethernet drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C8E4DEA.2050406@canonical.com>
References: <20100912223724.GA15934@electric-eye.fr.zoreil.com>
	<20100913095912.74d7f0f1@tron.localdomain>
	<4C8E4DEA.2050406@canonical.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Gardner <tim.gardner@canonical.com>
Date: Mon, 13 Sep 2010 10:14:34 -0600

> If not already staged, please consider including these commits for
> 2.6.32.y:
> 
> 024a07bacf8287a6ddfa83e9d5b951c5e8b4070e
> 81a95f049962ec20a9aed888e676208b206f0f2e
> 
> They are already included in 2.6.33.y and up, so its curious that they
> are not also included in 2.6.32.y as they do apply cleanly.

I'll take care of queueing these up to -stable, thanks.
