Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab1AZGuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 01:50:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48280
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583Ab1AZGt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 01:49:59 -0500
Date: Tue, 25 Jan 2011 22:50:34 -0800 (PST)
Message-Id: <20110125.225034.39182208.davem@davemloft.net>
To: alek.du@intel.com
Cc: buytenh@secretlab.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] langwell_gpio: Fix deprecated refs to irq_desc->chip
 and chip->eoi
From: David Miller <davem@davemloft.net>
In-Reply-To: <1865303E0DED764181A9D882DEF65FB685DF499ACF@shsmsx502.ccr.corp.intel.com>
References: <20110125.222948.112596409.davem@davemloft.net>
	<1865303E0DED764181A9D882DEF65FB685DF499ACF@shsmsx502.ccr.corp.intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Du, Alek" <alek.du@intel.com>
Date: Wed, 26 Jan 2011 14:48:02 +0800

> Another patch from Feng Tang already covers this and picked up by Andrew Morton.
> 
> [patch 04/23] langwell_gpio: modify EOI handling following change of kernel irq subsystem

Ok, thanks.
