Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab1H1Twp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 15:52:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:49736 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752148Ab1H1Twg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 15:52:36 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19+ww1tyUd+A/0w7XZPotARDsRthDpe9VM1SvrYim
	Mo+JS/O44PCILD
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] net/mac80211/debugfs: Convert to kstrou8_from_user
Date: Sun, 28 Aug 2011 21:52:31 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.3; KDE/4.4.5; x86_64; ; )
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1307478974-32727-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1307478974-32727-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108282152.32180.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 07 Juni 2011, 22:36:14 schrieb Peter Huewe:
> This patch replaces the code for getting an number from a
> userspace buffer by a simple call to kstrou8_from_user.
> This makes it easier to read and less error prone.
> 
> Since the old buffer was only 10 bytes long and the value is masked by a
> nibble-mask anyway, we don't need to use kstrtoul but rather kstrtou8.
> 
> Kernel Version: v3.0-rc2
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Any updates on this one?
Still applies to the latest linus' tree

Thanks,
Peter
