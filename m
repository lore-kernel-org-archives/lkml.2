Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab2JZMT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:19:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758598Ab2JZMT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:19:56 -0400
Date: Fri, 26 Oct 2012 14:19:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-kernel@vger.kernel.org, isdn@linux-pingi.de
Subject: Re: [PATCH] [trivial] isdn: Fix typo in isdn drivers
In-Reply-To: <1351090536-26458-1-git-send-email-standby24x7@gmail.com>
Message-ID: <alpine.LNX.2.00.1210261419300.19184@pobox.suse.cz>
References: <1351090536-26458-1-git-send-email-standby24x7@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012, Masanari Iida wrote:

> Fix spelling typo in debug messages within drivers/isdn.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/isdn/hardware/mISDN/mISDNisar.c | 2 +-
>  drivers/isdn/hisax/amd7930_fn.c         | 2 +-
>  drivers/isdn/hisax/isar.c               | 2 +-
>  drivers/isdn/pcbit/layer2.c             | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)

Ok, I will be applying this one.

-- 
Jiri Kosina
SUSE Labs
