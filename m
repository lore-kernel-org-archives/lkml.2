Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab2KVTAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:00:35 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33088 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab2KVTAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:00:30 -0500
Date: Thu, 22 Nov 2012 16:09:57 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 1/1] ARM: cache-l2x0: Fix compile time warnings when
 !CONFIG_OF
Message-ID: <20121122160957.GE10986@gmail.com>
References: <1353586067-9989-1-git-send-email-lee.jones@linaro.org>
 <20121122122633.GG5764@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121122122633.GG5764@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2012, Russell King - ARM Linux wrote:

> I assume you're working with an old kernel... this has already been
> fixed.

If by 'old' you mean a few -rc's, then yes.

I've rebased and the issue has gone away, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
