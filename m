Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2E3Hnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:43:51 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46522 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2E3Hnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:43:50 -0400
MIME-Version: 1.0
In-Reply-To: <4FC5CE2E.6000501@linaro.org>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
	<1338353260-10097-19-git-send-email-lee.jones@linaro.org>
	<CACRpkdYpCMRurpDgz5X-Qsv5qUgzeVX3S8trWHByTaw6R35_jg@mail.gmail.com>
	<4FC5CE2E.6000501@linaro.org>
Date: Wed, 30 May 2012 15:43:49 +0800
Message-ID: <CACRpkdZgf4TasFza0LW4nPaDkK-gqawKGDFhP2nJdTjG=+C58A@mail.gmail.com>
Subject: Re: [PATCH 18/22] mfd: Remove redundant Kconfig entry
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 3:37 PM, Lee Jones <lee.jones@linaro.org> wrote:

>> You need to move these dependencies under the AB8500_CORE config
>> entry instead.
>
> Already done and upstreamed: 21f082a66177852365df0c955ecaef50fba9a691

Yes the PRCMU driver will select this one, I was more thinking if it shoul
select both but this will work.
Acked-by.

Linus Walleij
