Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2DON6o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 09:58:44 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:45456 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab2DON6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 09:58:43 -0400
Date: Sun, 15 Apr 2012 15:58:35 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] avr32: drop HAVE_ARCH_BOOTMEM from Kconfig
Message-ID: <20120415135835.GA29603@samfundet.no>
References: <20120415092804.GA4947@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120415092804.GA4947@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sun 15 Apr 2012 11:28:04 +0200 or thereabout, Sam Ravnborg wrote:
> From f58a1c9f6717a6754fde691fb10f8eab7170dbc2 Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Sun, 15 Apr 2012 11:23:50 +0200
> Subject: [PATCH] avr32: drop HAVE_ARCH_BOOTMEM from Kconfig
> 
> The symbol is default to n - so no point in adding a symbol
> with def_bool n.
> Noticed iby Tejun when we removed this symbol from x86.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Tejun Heo <tj@kernel.org>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

-- 
mvh
Hans-Christian Egtvedt
