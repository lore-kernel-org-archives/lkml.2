Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab2DDTR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 15:17:57 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:42277 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564Ab2DDTRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 15:17:55 -0400
Date: Wed, 4 Apr 2012 12:17:54 -0700
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2 13/13] ARM: at91: dt: remove unit-address part for
 memory nodes
Message-ID: <20120404191754.GE10603@quad.lixom.net>
References: <cover.1333437885.git.nicolas.ferre@atmel.com>
 <1db62b280314855c35cb7a3188fc9d9cb8501948.1333437885.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1db62b280314855c35cb7a3188fc9d9cb8501948.1333437885.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 09:32:57AM +0200, Nicolas Ferre wrote:
> From: Ludovic Desroches <ludovic.desroches@atmel.com>
> 
> Having a unit-address different from 0 causes bad memory node detection
> during early_init_dt_scan_memory.

Sounds like a bug in the generic code to me? But specifying a unit
address on a non-ambiguous device node isn't necessary anyway, so this
patch is still a reasonable thing to do.

> Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: devicetree-discuss@lists.ozlabs.org

Acked-by: Olof Johansson <olof@lixom.net>



-Olof
