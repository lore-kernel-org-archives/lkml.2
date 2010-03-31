Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab0CaGmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 02:42:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50944
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932453Ab0CaGmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:42:35 -0400
Date: Tue, 30 Mar 2010 23:42:36 -0700 (PDT)
Message-Id: <20100330.234236.82716909.davem@davemloft.net>
To: joe@perches.com
Cc: romieu@fr.zoreil.com, sorbica@icplus.com.tw, jesse@icplus.com.tw,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next trivial] drivers/net/ipg: Remove invalid
 IPG_DDEBUG_MSG uses, neaten
From: David Miller <davem@davemloft.net>
In-Reply-To: <1269801345.1500.32.camel@Joe-Laptop.home>
References: <1269801345.1500.32.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 28 Mar 2010 11:35:45 -0700

> Some no longer valid IPG_DDEBUG_MSG uses are removed
> Validate IPG_DDEBUG_MSG arguments when not #defined
> Neaten #defines
> marco/macro typo correction
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
