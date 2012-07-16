Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab2GPFRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 01:17:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2GPFRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 01:17:41 -0400
Date: Sun, 15 Jul 2012 22:15:39 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] charger-manager: Fix build break related to EXTCON
Message-ID: <20120716051539.GA14597@lizard>
References: <1342413974-13219-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1342413974-13219-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 01:46:14PM +0900, Chanwoo Choi wrote:
> This patch select CONFIG_EXTCON to resolve below build break of charger-manager
> because charger-manager use API of EXTCON subsystem.
> 
> drivers/built-in.o: In function `charger_manager_probe':
> charger-manager.c:(.text+0x11d61a): undefined reference to `extcon_register_interest'
> charger-manager.c:(.text+0x11d7b6): undefined reference to `extcon_unregister_interest'
> drivers/built-in.o: In function `charger_manager_remove':
> charger-manager.c:(.devexit.text+0x8f3): undefined reference to `extcon_unregister_interest'
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
