Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1ACMwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 07:52:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:43685 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab1ACMwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 07:52:39 -0500
Date: Mon, 3 Jan 2011 13:52:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Weil <weil@mail.berlios.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix spelling milisecond -> millisecond in comments and
 debug messages
In-Reply-To: <1293978101-5252-1-git-send-email-weil@mail.berlios.de>
Message-ID: <alpine.LNX.2.00.1101031352150.26685@pobox.suse.cz>
References: <1293978101-5252-1-git-send-email-weil@mail.berlios.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Jan 2011, Stefan Weil wrote:

> Cc: Jiri Kosina <trivial@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Stefan Weil <weil@mail.berlios.de>
> ---
>  arch/arm/mach-bcmring/include/csp/tmrHw.h |    4 ++--
>  drivers/acpi/apei/einj.c                  |    2 +-
>  drivers/acpi/apei/erst.c                  |    2 +-
>  drivers/gpu/drm/nouveau/nouveau_bios.c    |    4 ++--
>  drivers/net/wireless/wl1251/wl1251.h      |    2 +-
>  drivers/net/wireless/wl12xx/wl1271.h      |    4 ++--
>  6 files changed, 9 insertions(+), 9 deletions(-)

Hi,

I have folded this together with the 'meassage -> message' fix and 
applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
