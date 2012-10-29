Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761028Ab2J2XEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 19:04:40 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:37997 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab2J2XEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 19:04:38 -0400
Date: Tue, 30 Oct 2012 00:01:39 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Cyril Brulebois <kibi@debian.org>
Cc: nic_swsd@realtek.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8169: Fix WoL on RTL8168d/8111d.
Message-ID: <20121029230139.GA17476@electric-eye.fr.zoreil.com>
References: <1351392414-32219-1-git-send-email-kibi@debian.org>
 <20121028230523.GA26778@electric-eye.fr.zoreil.com>
 <20121029002140.GK6195@mraw.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029002140.GK6195@mraw.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyril Brulebois <kibi@debian.org> :
[...]
> Thanks. Should I re-send with that as reference, or will you amend the
> patch once you're done with your testing?

It would be nice to resend, directly to netdev and davem.

Shutdown Wol behaved as expected with 3.7-rc3 for both cards: unicast WoL
failed without the patch while broadcast WoL worked. Unicast and broadcast
worked after the patch.

-- 
Ueimor
