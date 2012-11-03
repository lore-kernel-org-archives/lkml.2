Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab2KCTRD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 15:17:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57977 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab2KCTRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 15:17:00 -0400
Date: Sat, 03 Nov 2012 15:16:59 -0400 (EDT)
Message-Id: <20121103.151659.1731852488102322283.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: kibi@debian.org, netdev@vger.kernel.org, nic_swsd@realtek.com,
        hayeswang@realtek.com, linux-kernel@vger.kernel.org,
        florent.fourcot@enst-bretagne.fr
Subject: Re: [PATCH v2] r8169: Fix WoL on RTL8168d/8111d.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121101222113.GB7708@electric-eye.fr.zoreil.com>
References: <20121028230523.GA26778@electric-eye.fr.zoreil.com>
	<1351728046-32105-1-git-send-email-kibi@debian.org>
	<20121101222113.GB7708@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Thu, 1 Nov 2012 23:21:13 +0100

> Cyril Brulebois <kibi@debian.org> :
>> This regression was spotted between Debian squeeze and Debian wheezy
>> kernels (respectively based on 2.6.32 and 3.2). More info about
>> Wake-on-LAN issues with Realtek's 816x chipsets can be found in the
>> following thread: http://marc.info/?t=132079219400004
> 
> David, please apply to -net.

Done.
