Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2KQVy0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 16:54:26 -0500
Received: from void.printf.net ([89.145.121.20]:50383 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab2KQVyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 16:54:23 -0500
From: Chris Ball <cjb@laptop.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Standardise capability type
References: <1352896551-17948-1-git-send-email-lee.jones@linaro.org>
Date: Sat, 17 Nov 2012 16:54:17 -0500
In-Reply-To: <1352896551-17948-1-git-send-email-lee.jones@linaro.org> (Lee
	Jones's message of "Wed, 14 Nov 2012 12:35:51 +0000")
Message-ID: <87haon99py.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee, 

Pushed to mmc-next for 3.8 with a minor change:

On Wed, Nov 14 2012, Lee Jones wrote:
> There are discrepancies with regards to how MMC capabilities
> are carried throughout the subsystem. Let's standardise them
> to elevate any confusion.

I think you meant "eliminate" here.  :)  Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
