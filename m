Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab1BVIZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:25:35 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:39658 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1BVIZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:25:34 -0500
Date: Tue, 22 Feb 2011 09:21:53 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] r8169: fix the wrong parameter of point address
Message-ID: <20110222082153.GA12463@electric-eye.fr.zoreil.com>
References: <1298356917-486-1-git-send-email-hayeswang@realtek.com> <1298356917-486-3-git-send-email-hayeswang@realtek.com> <20110222080017.GA12453@electric-eye.fr.zoreil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222080017.GA12453@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu <romieu@fr.zoreil.com> :
> Hayes Wang <hayeswang@realtek.com> :
> > Correct the parameter of rtl8168_oob_notify. It results in the
> > wrong point address and influences RTL8168DP.
> 
> Please send this one separately as a patch against current kernel
> tree as it is clearly a bugfix. The remaining patches are probably
> more -next material.

Correct me if I am wrong:
- #3 and #1 are bugfixes
- can you specify if #4 and #5 are either bugfixes, optimizations or cleanups ?
- #2 adds support for a new chipset

-- 
Ueimor
