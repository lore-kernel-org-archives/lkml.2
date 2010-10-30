Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab0J3XYO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 19:24:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39125
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753921Ab0J3XYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 19:24:12 -0400
Date: Sat, 30 Oct 2010 16:24:36 -0700 (PDT)
Message-Id: <20101030.162436.115938810.davem@davemloft.net>
To: dkirjanov@kernel.org
Cc: bjorn.helgaas@hp.com, amit.salecha@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: NULL pointer dereference at netxen_nic_probe+0x813/0x9a0
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CCC7868.60104@kernel.org>
References: <4CCB24CA.3050106@kernel.org>
	<20101029.125403.71123384.davem@davemloft.net>
	<4CCC7868.60104@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Kirjanov <dkirjanov@kernel.org>
Date: Sat, 30 Oct 2010 23:56:24 +0400

> [PATCH] netxen_nic: Fix the tx queue manipulation bug in netxen_nic_probe
> 
> We should not stop the egress queue during probe because it is wrong.
> 
> Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>

Applied.
