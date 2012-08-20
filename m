Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2HTULl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:11:41 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48146 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab2HTULj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:11:39 -0400
MIME-Version: 1.0
In-Reply-To: <1345307035-3545-5-git-send-email-festevam@gmail.com>
References: <1345307035-3545-1-git-send-email-festevam@gmail.com>
	<1345307035-3545-5-git-send-email-festevam@gmail.com>
Date: Mon, 20 Aug 2012 13:11:38 -0700
Message-ID: <CA+8MBb+OtvkUS8z9e-PZ3jHrb6PAkgXmtgH=Gsayex48zTE_uw@mail.gmail.com>
Subject: Re: [PATCH 05/11] ia64: defconfig: Remove CONFIG_MISC_DEVICES
From: Tony Luck <tony.luck@gmail.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 9:23 AM, Fabio Estevam <festevam@gmail.com> wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> commit 7c5763 (drivers:misc: Remove MISC_DEVICES config option) removed
> CONFIG_MISC_DEVICES option, so remove the occurrences from the config files
> as well

Applied (though I did add a few extra characters to that 7c5763
reference in the commit
message ... six works today, but seems like it is just waiting to have
a collision).

Thanks

-Tony
