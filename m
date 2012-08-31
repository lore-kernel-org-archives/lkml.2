Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2HaS3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 14:29:01 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:38012 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab2HaS27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 14:28:59 -0400
Date: Fri, 31 Aug 2012 20:12:29 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: David Madore <david+ml@madore.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel 3.2.27 on arm: WARNING: at mm/page_alloc.c:2109 __alloc_pages_nodemask+0x1d4/0x68c()
Message-ID: <20120831181229.GA8898@electric-eye.fr.zoreil.com>
References: <20120829002548.GA7063@aldebaran.gro-tsen.net> <20120829193220.GA6389@electric-eye.fr.zoreil.com> <20120831105936.GA4704@aldebaran.gro-tsen.net> <20120831135757.GA26488@aldebaran.gro-tsen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120831135757.GA26488@aldebaran.gro-tsen.net>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Madore <david+ml@madore.org> :
[...]
> [  268.976317] ieee80211 phy0: failed to reallocate TX buffer
> [  716.880515] ieee80211 phy0: failed to reallocate TX buffer
> [ 1160.877677] ieee80211 phy0: failed to reallocate TX buffer
> 
> Could they be related?

Yes. This is a pskb_expand_head failure from net/mac80211/tx.c.
The router is experiencing GFP_ATOMIC allocation failure

You should monitor /proc/slabinfo content. A pig may appear over time.

-- 
Ueimor
