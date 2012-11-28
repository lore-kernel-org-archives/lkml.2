Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab2K1HDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 02:03:38 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42294 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2K1HDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 02:03:37 -0500
Date: Tue, 27 Nov 2012 23:03:32 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 3/3] Input: bu21013_ts - Add support for Device Tree
 booting
Message-ID: <20121128070332.GC23378@core.coreip.homeip.net>
References: <1354021990-16978-1-git-send-email-lee.jones@linaro.org>
 <1354021990-16978-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354021990-16978-4-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, Nov 27, 2012 at 01:13:10PM +0000, Lee Jones wrote:
> Now we can register the BU21013_ts touch screen when booting with
> Device Tree enabled. Here we parse all the necessary components
> previously expected to be passed from platform data.

I applied these 3 patches, but for DT we also need to specify compatible
ID and set up of_match_table pointer. Please send me a follow-up patches
doing that and also describing DT bindings for BU21013.

Thanks.

-- 
Dmitry
