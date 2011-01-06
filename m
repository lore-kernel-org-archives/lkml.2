Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab1AFPI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:08:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58261 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab1AFPIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:08:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=omHa2K6i+Hnw/UFDBSFkzYwSCrPsG3ZCfQGmUdQpRx4txF/cYgQxfXCvpy0crgKZKW
         6iCz02MWu5Hl88RqvWndoJ0AOQeNxGsPo/8hUnmIoIlCxFWM7XPtuD5dz6jMABv8sC4J
         9PF4W7cbULVLH3T2pe2EQZeVgNdqwRUK6gxlY=
Subject: Re: [patch v2] mtd: pxa3xx_nand: NULL dereference in
 pxa3xx_nand_probe
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Dan Carpenter <error27@gmail.com>
Cc: Sven Neumann <s.neumann@raumfeld.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        Daniel Mack <daniel@caiaq.de>, leiwen@marvell.com,
        haojian.zhuang@marvell.com, David.Woodhouse@intel.com,
        eric.y.miao@gmail.com, Artem.Bityutskiy@nokia.com
In-Reply-To: <20110106140536.GB1717@bicker>
References: <1294227801.3996.62.camel@sven> <20110106124525.GA1717@bicker>
	 <1294321502.2218.5.camel@sven>  <20110106140536.GB1717@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 17:08:20 +0200
Message-ID: <1294326500.2219.8.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 17:05 +0300, Dan Carpenter wrote:
> "info->cmdset" gets dereferenced in __readid() so it needs to be
> initialized earlier in the function.  This bug was introduced in 
> 18c81b1828f8 "mtd: pxa3xx_nand: remove the flash info in driver
> structure".
> 
> Cc: stable@kernel.org [2.6.37+]
> Reported-and-tested-by: Sven Neumann <s.neumann@raumfeld.com>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> v2:  changed the commit text.  added stable@kernel.org and a reported-by tag.

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

