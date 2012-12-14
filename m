Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab2LNCxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 21:53:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32933 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753444Ab2LNCxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 21:53:16 -0500
Date: Fri, 14 Dec 2012 11:53:09 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org
Subject: Re: [PATCH 01/12] regulator: gpio-regulator: Demote GPIO Regulator
 driver to start later
Message-ID: <20121214025307.GB4478@opensource.wolfsonmicro.com>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
 <1355129761-8088-2-git-send-email-lee.jones@linaro.org>
 <20121210140751.GB6103@opensource.wolfsonmicro.com>
 <20121210142836.GG9362@gmail.com>
 <20121210143141.GG6103@opensource.wolfsonmicro.com>
 <20121213115524.GI27617@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213115524.GI27617@gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 11:55:24AM +0000, Lee Jones wrote:

> I understand your logic, hence why I wrote such a lengthy commit
> message. However, I'm not sure I see a logical way around it. Asking
> all users of MMCI to provide a not-regulator to declare that a
> secondary regulator isn't available seems a little unreasonable to me.

> Is there anything else we can do?

Have all the people setting up this secondary regulator explicitly
declare it?
