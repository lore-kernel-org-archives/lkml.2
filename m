Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab1EPVZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:25:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38448
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754863Ab1EPVZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:25:36 -0400
Date: Mon, 16 May 2011 14:25:04 -0700 (PDT)
Message-Id: <20110516.142504.115922083.davem@davemloft.net>
To: tfransosi@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide/ide-scan-pci.c: Use for_each_pci_dev().
From: David Miller <davem@davemloft.net>
In-Reply-To: <1304287825-8023-1-git-send-email-tfransosi@gmail.com>
References: <1304287825-8023-1-git-send-email-tfransosi@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thiago Farina <tfransosi@gmail.com>
Date: Sun,  1 May 2011 19:10:25 -0300

> Use for_each_pci_dev() to simplify the code.
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>

Applied.
