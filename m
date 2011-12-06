Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424Ab1LFLt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:49:29 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36252 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933192Ab1LFLt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:49:27 -0500
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Scott Wood <scottwood@freescale.com>
Cc: shuo.liu@freescale.com, Artem.Bityutskiy@nokia.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, akpm@linux-foundation.org,
        dwmw2@infradead.org
Date: Tue, 06 Dec 2011 13:49:19 +0200
In-Reply-To: <4EDD1F90.300@freescale.com>
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>
	 <1322973098-2528-3-git-send-email-shuo.liu@freescale.com>
	 <1323067628.2316.29.camel@koala> <4EDD1F90.300@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323172165.2163.3.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 13:46 -0600, Scott Wood wrote:
> Because this is a controller resource, shared by multiple NAND chips
> that may be different page sizes (even if not, it's adding another point
> of synchronization required between initialization of different chips).
>  I don't think it's worth the gymnastics to save a few KiB.

OK, I see.

Artem.

