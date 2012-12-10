Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab2LJUlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 15:41:24 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58775 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab2LJUlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 15:41:23 -0500
From: Florian Fainelli <florian@openwrt.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, gregkh@linux-foundation.org
Subject: Re: [PATCH] Input: matrix-keymap - provide proper module license
Date: Mon, 10 Dec 2012 21:41:20 +0100
Message-ID: <1523630.HActN61KnA@bender>
Organization: OpenWrt
User-Agent: KMail/4.8.5 (Linux/3.2.0-34-generic; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1355171132-14951-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1355171132-14951-1-git-send-email-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2012 12:25:32 Dmitry Torokhov wrote:
> From: Florian Fainelli <florian@openwrt.org>
> 
> The matrix-keymap module is currently lacking a proper module license,
> add one so we don't have this module tainting the entire kernel. This
> issue has been present since commit 1932811f (Input: matrix-keymap -
> uninline and prepare for device tree support)
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> CC: stable@vger.kernel.org
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
> 
> Hi Linus,
> 
> Please apply before 3.8 final if possible. Sending directly as my normal
> branch has some extra stuff in it...

Thank you Dmitry! In fact, this issue has been present since 3.5, so it might
be worth backporting this fix to -stable tree as well.
-- 
Florian
