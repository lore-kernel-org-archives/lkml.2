Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab1GIJ5K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 05:57:10 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43849 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab1GIJ5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 05:57:09 -0400
Date: Sat, 09 Jul 2011 02:57:05 -0700 (PDT)
Message-Id: <20110709.025705.727560311771106736.davem@davemloft.net>
To: joe@perches.com
Cc: sathya.perla@emulex.com, subbu.seetharaman@emulex.com,
        ajit.khaparde@emulex.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] benet: Add missing comma between constant string
 array
From: David Miller <davem@davemloft.net>
In-Reply-To: <8c2d9b2ff796489a39408fade30fc93ed6040b3c.1310187270.git.joe@perches.com>
References: <cover.1310187270.git.joe@perches.com>
	<8c2d9b2ff796489a39408fade30fc93ed6040b3c.1310187270.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 09 Jul 2011 02:57:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri,  8 Jul 2011 23:20:23 -0700

> Multiple quoted strings are concatenated without comma separators.
> 
> Make the arrays const while there.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
