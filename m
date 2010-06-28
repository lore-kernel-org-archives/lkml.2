Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab0F1Sd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 14:33:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55366
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320Ab0F1SdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 14:33:25 -0400
Date: Mon, 28 Jun 2010 11:33:36 -0700 (PDT)
Message-Id: <20100628.113336.112593735.davem@davemloft.net>
To: liberty@extricom.com
Cc: linux-kernel@vger.kernel.org, galak@kernel.crashing.org
Subject: Re: [PATCH] gainfar.c : skb_over_panic (kernel-2.6.32.15)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C2855D4.5050507@extricom.com>
References: <4C232B13.5000706@extricom.com>
	<20100624.145225.70206491.davem@davemloft.net>
	<4C2855D4.5050507@extricom.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eran Liberty <liberty@extricom.com>
Date: Mon, 28 Jun 2010 10:57:08 +0300

> This code has proved to be insufficient and produce
> skb_over_panic. The proposed patch fix this.

Then you have to post a patch relative to the current code, rather than
against the code as it was several releases ago.

Your patch didn't apply, so I can't use it.
