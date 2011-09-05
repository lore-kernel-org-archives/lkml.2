Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab1IEVlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 17:41:02 -0400
Received: from lo.gmane.org ([80.91.229.12]:35446 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab1IEVk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 17:40:58 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthieu CASTET <castet.matthieu@free.Fr>
Subject: Re: [PATCH 4/8] regmap: Add the LZO cache support
Date: Mon, 5 Sep 2011 21:40:45 +0000 (UTC)
Message-ID: <loom.20110905T233927-790@post.gmane.org>
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com> <1314978375-11539-5-git-send-email-dp@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.57.151.96 (Mozilla/5.0 (Windows; U; Windows NT 5.1; chrome://global/locale/intl.properties) AppleWebKit/525.19 (KHTML, like Gecko) Chrome/0.4.154.29 Safari/525.19)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitris Papastamos <dp <at> opensource.wolfsonmicro.com> writes:

> 
> This patch adds support for LZO compression when storing the register
> cache.
> 
> For a typical device whose register map would normally occupy 25kB or 50kB
> by using the LZO compression technique, one can get down to ~5-7kB.  
Do you have example of such case ?

Caching 25kB or 50kB looks crazy.

