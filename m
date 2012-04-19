Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab2DSQ4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:56:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37734 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab2DSQ4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:56:03 -0400
MIME-Version: 1.0
In-Reply-To: <m2pqb31yxk.fsf@igel.home>
References: <m2pqb31yxk.fsf@igel.home>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 19 Apr 2012 10:55:40 -0600
X-Google-Sender-Auth: b6r5NqxWzNpgDTUh_grxr3eTL3c
Message-ID: <CACxGe6sKrO8U4JPKs0cvB24ZTsPNx430FhiE--JFAQzNb_=1og@mail.gmail.com>
Subject: Re: [PATCH] irqdomain: fix typo in IRQ_BITMAP_BITS definition
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 10:14 AM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> 8196 is an odd number, change it to the intended 8192.
>
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
> ---
> Shouldn't it actually be just 8192 or maybe max(NR_IRQS, 8192)?

The number is completely arbitrary.  It doesn't actually matter.

g.
