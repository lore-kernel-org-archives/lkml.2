Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab2J1X1O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:27:14 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:34235 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab2J1X1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:09 -0400
Date: Mon, 29 Oct 2012 00:05:23 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Cyril Brulebois <kibi@debian.org>
Cc: nic_swsd@realtek.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8169: Fix WoL on RTL8168d/8111d.
Message-ID: <20121028230523.GA26778@electric-eye.fr.zoreil.com>
References: <1351392414-32219-1-git-send-email-kibi@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351392414-32219-1-git-send-email-kibi@debian.org>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyril Brulebois <kibi@debian.org> :
> This regression was spotted between Debian squeeze and Debian wheezy
> kernels (respectively based on 2.6.32 and 3.2). The fix was inspired
> by <http://www.spinics.net/lists/netdev/msg178543.html>, using
> RTL_GIGA_MAC_VER_{25,26} for the RTL8168d/8111d chipset.

If someone experiences problems or has questions about WoL with
Realtek's 816x chipsets, http://marc.info/?t=132079219400004 would
imho be a better reference.

[...]
> Tested on top of a 3.2.23 kernel.

It should still be relevant for current kernel. I'll give it a try.

[...]
> It looks like RTL_GIGA_MAC_VER_{25,26} are kinda supposed to go
> together so I kept both. Florent's testing gave the following results:
>  - RTL_GIGA_MAC_VER_25 only: FAIL.
>  - RTL_GIGA_MAC_VER_26 only: SUCCESS.
>  - RTL_GIGA_MAC_VER_25 + RTL_GIGA_MAC_VER_26: SUCCESS.

I don't understand the VER_25 vs VER_26 difference.

-- 
Ueimor
