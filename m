Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030970Ab2CFWMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:12:43 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40349 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965262Ab2CFWMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:12:42 -0500
Date: Tue, 06 Mar 2012 17:08:19 -0500 (EST)
Message-Id: <20120306.170819.2135873666210523674.davem@davemloft.net>
To: dhdang@apm.com
Cc: benh@kernel.crashing.org, paulus@samba.org, jwboyer@gmail.com, sr@denx.de,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/2] powerpc/44x: Add new compatible value for EMAC
 node of APM821XX dts file.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330945062-15760-1-git-send-email-dhdang@apm.com>
References: <1330920224-3006-1-git-send-email-dhdang@apm.com>
	<1330945062-15760-1-git-send-email-dhdang@apm.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 06 Mar 2012 14:08:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Duc Dang <dhdang@apm.com>
Date: Mon,  5 Mar 2012 17:57:42 +0700

> This compatible value will be used to distinguish some special features of APM821XX EMAC: no half duplex mode support, configuring jumbo frame.
> 
> Signed-off-by: Duc Dang <dhdang@apm.com>

Applied.
