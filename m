Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab2EJQch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:32:37 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51881 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab2EJQcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:32:33 -0400
Date: Thu, 10 May 2012 12:30:24 -0400 (EDT)
Message-Id: <20120510.123024.2157290550457495698.davem@davemloft.net>
To: jussi.kivilinna@mbnet.fi
Cc: joe@perches.com, fubar@us.ibm.com, andy@greyhouse.net, benve@cisco.com,
        roprabhu@cisco.com, neepatel@cisco.com, nistrive@cisco.com,
        grundler@parisc-linux.org, anirban.chakraborty@qlogic.com,
        sony.chacko@qlogic.com, linux-driver@qlogic.com,
        linux-net-drivers@solarflare.com, bhutchings@solarflare.com,
        cmetcalf@tilera.com, linville@tuxdriver.com, jirislaby@gmail.com,
        mickflemm@gmail.com, mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
        vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
        chunkeey@googlemail.com, stas.yakovlev@gmail.com, sgruszka@redhat.com,
        johannes.berg@intel.com, wey-yi.w.guy@intel.com, ilw@linux.intel.com,
        buytenh@wantstofly.org, Larry.Finger@lwfinger.net,
        chaoming_li@realsil.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath5k-devel@venema.h4ckr.net, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH 1/3] drivers/net: Convert compare_ether_addr to
 ether_addr_equal
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120510173201.16131du3cg90nybo@www.81.fi>
References: <cover.1336618707.git.joe@perches.com>
	<7c9881a67c52c2f218480b6742155b6d6928122d.1336618708.git.joe@perches.com>
	<20120510173201.16131du3cg90nybo@www.81.fi>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 09:30:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Never, EVER, quote an entire large patch just to make a comment
on one small hunk.

I very nearly missed what you had to say because when scrolling
through it it appeared as if you made no comments at all.

Again, NEVER, EVER, do this.  It's extremely anti-social.  Edit out
the irrelevant quoted content when replying to people, always.
