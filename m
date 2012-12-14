Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2LNSQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:16:32 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48896 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab2LNSQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:16:28 -0500
Date: Fri, 14 Dec 2012 13:16:26 -0500 (EST)
Message-Id: <20121214.131626.1070000941381130402.davem@davemloft.net>
To: khlebnikov@openvz.org
Cc: linux-kernel@vger.kernel.org, peppe.cavallaro@st.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 07/12] stmmac: fix platform driver unregistering
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121214110251.11019.9914.stgit@zurg>
References: <20121214110229.11019.63713.stgit@zurg>
	<20121214110251.11019.9914.stgit@zurg>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Fri, 14 Dec 2012 15:02:51 +0400

> This patch fixes platform device drivers unregistering and adds proper error
> handing on module loading.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Applied.
