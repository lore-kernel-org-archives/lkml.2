Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab2A3Xp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:45:28 -0500
Received: from [206.117.179.246] ([206.117.179.246]:60610 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753070Ab2A3XpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:45:24 -0500
Message-ID: <1327967103.4230.7.camel@joe2Laptop>
Subject: Re: [PATCH 1/1] wireless: remove return in _rtl_pci_switch_clk_req
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Devendra.Naga" <devendra.aaru@gmail.com>, chaoming_li@realsil.com.cn,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 30 Jan 2012 15:45:03 -0800
In-Reply-To: <4F27294D.30302@lwfinger.net>
References: <1327927591-28070-1-git-send-email-devendra.aaru@gmail.com>
	 <4F27294D.30302@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 17:35 -0600, Larry Finger wrote:
> The patch is OK, but the patch subject is bad. You should have "[PATCH] 
> rtlwifi:...". Your patch is for rtlwifi, not wireless.

Hi Devendra.

A reasonable rule of thumb is use the deepest directory
path basename you can to prefix the patch.
Something like:

[PATCH] $(basename $(dirname $file)): terse description

If you are patching drivers/net/ethernet/realtek/apt.c
this becomes:

[PATCH] realtek: terse description

There are some exceptions though.  One of them
is if the patch is in staging, prefix with
[PATCH] staging: $(basename $(dirname $file)): description

cheers, Joe

