Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab2KKWa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 17:30:28 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:39867 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2KKWa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 17:30:26 -0500
Date: Sun, 11 Nov 2012 23:07:25 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Dayanidhi Sreenivasan <dayanidhi.sreenivasan@gmail.com>
Cc: nic_swsd@realtek.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: [PATCH 1/1] r8169: Removed unused macros from r8169.c
Message-ID: <20121111220725.GA873@electric-eye.fr.zoreil.com>
References: <1352652518-2287-1-git-send-email-dayanidhi.sreenivasan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352652518-2287-1-git-send-email-dayanidhi.sreenivasan@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dayanidhi Sreenivasan <dayanidhi.sreenivasan@gmail.com> :
[...]

I have fixed the conflict with the driver in net-next due to removal of
the SafeMtu #define and pushed the result in branch davem-next.r8169 at
git://violet.fr.zoreil.com/romieu/linux

Next time you send a patch, please specify the branch it should apply
to and check it does not conflict.

Thanks.

-- 
Ueimor
