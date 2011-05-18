Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab1ERWD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 18:03:59 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43750 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab1ERWD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 18:03:56 -0400
Date: Wed, 18 May 2011 18:03:51 -0400 (EDT)
Message-Id: <20110518.180351.1629402840214471214.davem@davemloft.net>
To: denzzzhome@yahoo.com
Cc: info@mocean-labs.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: ks8842 Fix crash on received packet when
 in PIO mode.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110518.180304.1707025648201926668.davem@davemloft.net>
References: <2062.44194.qm@web120510.mail.ne1.yahoo.com>
	<20110518.180304.1707025648201926668.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 May 2011 15:03:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


BTW, you also sent this to the wrong list.

Networking patches must be sent to netdev@vger.kernel.org
