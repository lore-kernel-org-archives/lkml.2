Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab2HaLI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 07:08:28 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55389 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab2HaLI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 07:08:27 -0400
Date: Fri, 31 Aug 2012 12:08:22 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com, arnd@arndb.de
Subject: Re: [rtc-linux] [PATCH 1/1] drivers/rtc/rtc-ab8500.c: Revoke Device
 Tree enablement
Message-ID: <20120831110818.GA5962@gmail.com>
References: <1344527828-6283-1-git-send-email-lee.jones@linaro.org>
 <1344527828-6283-3-git-send-email-lee.jones@linaro.org>
 <CACRpkdZa-72QogrZ-P5jbDHTTX64babZo3ydjzfgC-4LWUBfMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZa-72QogrZ-P5jbDHTTX64babZo3ydjzfgC-4LWUBfMg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 10:32:02AM +0200, Linus Walleij wrote:
> On Thu, Aug 9, 2012 at 5:57 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > All AB8500 devices are now registered via MFD core, so Device Tree
> > capability is no longer required for probing. Here we pull the DT
> > match table to ensure we're no longer probed during Device Tree
> > start-up.
> >
> > CC: Alessandro Zummo <a.zummo@towertech.it>
> > CC: rtc-linux@googlegroups.com
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

I'm guessing we still need Alessandro's Ack?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
