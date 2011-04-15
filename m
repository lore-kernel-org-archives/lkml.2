Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab1DOFEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 01:04:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34165
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753103Ab1DOFEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 01:04:30 -0400
Date: Thu, 14 Apr 2011 22:03:55 -0700 (PDT)
Message-Id: <20110414.220355.189708723.davem@davemloft.net>
To: decot@google.com
Cc: fubar@us.ibm.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net-bonding: Fix minor sparse complaints
From: David Miller <davem@davemloft.net>
In-Reply-To: <1302744151-12452-1-git-send-email-decot@google.com>
References: <1302744151-12452-1-git-send-email-decot@google.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@google.com>
Date: Wed, 13 Apr 2011 18:22:29 -0700

> This gets rid of minor sparse complaints:
> drivers/net/bonding/bond_main.c:4361:4: warning: do-while statement is not a compound statement
> drivers/net/bonding/bond_main.c:243:12: warning: symbol 'bond_mode_name' was not declared. Should it be static?
> 
> Signed-off-by: David Decotigny <decot@google.com>

Applied.
