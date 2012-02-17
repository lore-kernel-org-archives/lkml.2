Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2BQEie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 23:38:34 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61646 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab2BQEic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 23:38:32 -0500
MIME-Version: 1.0
In-Reply-To: <1329412171-20704-2-git-send-email-danny.kukawka@bisect.de>
References: <1329412171-20704-1-git-send-email-danny.kukawka@bisect.de> <1329412171-20704-2-git-send-email-danny.kukawka@bisect.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 16 Feb 2012 23:38:11 -0500
X-Google-Sender-Auth: MT4P9sCIfW8fanUHWtY3fLD1P3w
Message-ID: <CAMjpGUdJjG3OExzHWd8+FwWsG-vCsL-NVe=ivS5VeeV6G0-_Tw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] arch/blackfin: don't generate random mac in bfin_get_ether_addr()
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: linux-kernel@vger.kernel.org, Danny Kukawka <dkukawka@suse.de>,
        uclinux-dist-devel@blackfin.uclinux.org,
        "David S. Miller" <davem@davemloft.net>, Bob Liu <lliubbo@gmail.com>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Miao <realmz6@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Scott Jiang <scott.jiang@analog.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 12:09, Danny Kukawka wrote:
> Changed bfin_get_ether_addr() to return a state and to
> set no random mac address if the board don't provide one.
>
> Let the caller of bfin_get_ether_addr() set a random mac
> address if the return value is not 0.

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
