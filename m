Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab2LSQ5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 11:57:44 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:46222 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab2LSQ5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 11:57:33 -0500
Date: Wed, 19 Dec 2012 16:57:31 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: OMAP4: PRM: Correct wrong instance usage for reading
 reset sources
In-Reply-To: <1355911588-21977-2-git-send-email-ivan.khoronzhuk@ti.com>
Message-ID: <alpine.DEB.2.00.1212191657260.16873@utopia.booyaka.com>
References: <1355911588-21977-1-git-send-email-ivan.khoronzhuk@ti.com> <1355911588-21977-2-git-send-email-ivan.khoronzhuk@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012, Ivan Khoronzhuk wrote:

> To read reset sources registers we have to use PRM_DEVICE_INST
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>

Thanks, queued for v3.8-rc fixes.


- Paul
