Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab2BTAG0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:06:26 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40721 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab2BTAGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:06:23 -0500
Date: Sun, 19 Feb 2012 19:05:19 -0500 (EST)
Message-Id: <20120219.190519.2247992297753168519.davem@davemloft.net>
To: vapier@gentoo.org
Cc: danny.kukawka@bisect.de, linux-kernel@vger.kernel.org, dkukawka@suse.de,
        uclinux-dist-devel@blackfin.uclinux.org, lliubbo@gmail.com,
        sonic.zhang@analog.com, paul.gortmaker@windriver.com,
        realmz6@gmail.com, lars@metafoo.de, scott.jiang@analog.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] arch/blackfin: don't generate random mac in
 bfin_get_ether_addr()
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMjpGUdJjG3OExzHWd8+FwWsG-vCsL-NVe=ivS5VeeV6G0-_Tw@mail.gmail.com>
References: <1329412171-20704-1-git-send-email-danny.kukawka@bisect.de>
	<1329412171-20704-2-git-send-email-danny.kukawka@bisect.de>
	<CAMjpGUdJjG3OExzHWd8+FwWsG-vCsL-NVe=ivS5VeeV6G0-_Tw@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 19 Feb 2012 16:05:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 16 Feb 2012 23:38:11 -0500

> On Thu, Feb 16, 2012 at 12:09, Danny Kukawka wrote:
>> Changed bfin_get_ether_addr() to return a state and to
>> set no random mac address if the board don't provide one.
>>
>> Let the caller of bfin_get_ether_addr() set a random mac
>> address if the return value is not 0.
> 
> Acked-by: Mike Frysinger <vapier@gentoo.org>

Applied.
