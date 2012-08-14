Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab2HNIcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:32:07 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60717 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2HNIcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:32:03 -0400
MIME-Version: 1.0
In-Reply-To: <1344527828-6283-3-git-send-email-lee.jones@linaro.org>
References: <1344527828-6283-1-git-send-email-lee.jones@linaro.org>
	<1344527828-6283-3-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 10:32:02 +0200
Message-ID: <CACRpkdZa-72QogrZ-P5jbDHTTX64babZo3ydjzfgC-4LWUBfMg@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH 1/1] drivers/rtc/rtc-ab8500.c: Revoke Device
 Tree enablement
From: Linus Walleij <linus.walleij@linaro.org>
To: rtc-linux@googlegroups.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:57 PM, Lee Jones <lee.jones@linaro.org> wrote:

> All AB8500 devices are now registered via MFD core, so Device Tree
> capability is no longer required for probing. Here we pull the DT
> match table to ensure we're no longer probed during Device Tree
> start-up.
>
> CC: Alessandro Zummo <a.zummo@towertech.it>
> CC: rtc-linux@googlegroups.com
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
