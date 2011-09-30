Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab1I3ISD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 04:18:03 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:50107 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab1I3ISA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 04:18:00 -0400
Date: Fri, 30 Sep 2011 02:17:59 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Abhilash K V <abhilash.kv@ti.com>
cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        b-cousson@ti.com, aneesh@ti.com, khilman@ti.com,
        santosh.shilimkar@ti.com, christian.gmeiner@gmail.com
Subject: Re: [PATCH v5 1/3] AM35x: Using OMAP3 generic hwmods
In-Reply-To: <1317363153-10259-2-git-send-email-abhilash.kv@ti.com>
Message-ID: <alpine.DEB.2.00.1109300217260.12185@utopia.booyaka.com>
References: <1317363153-10259-1-git-send-email-abhilash.kv@ti.com> <1317363153-10259-2-git-send-email-abhilash.kv@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhilash,

On Fri, 30 Sep 2011, Abhilash K V wrote:

> From: Abhilash K V <abhilash.kv@ti.com>
> 
> Removing modules iva, sr1_hwmod, sr2_hwmod, mailbox from
> the base omap3xxx_hwmods list, so that they can be excluded
> for am35x.
> 
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>

Looks good to me, provisionally queued for 3.2 fixes.


- Paul
