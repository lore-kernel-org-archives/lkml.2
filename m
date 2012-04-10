Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190Ab2DJTVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 15:21:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65267 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758885Ab2DJTVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 15:21:47 -0400
Message-ID: <1334085702.6046.7.camel@flow>
Subject: Re: [PATCH 3/3] mfd: asic3: Add PCMCIA/CF support
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Date: Tue, 10 Apr 2012 21:21:42 +0200
In-Reply-To: <1333644304.97070.YahooMailClassic@web29013.mail.ird.yahoo.com>
References: <1333644304.97070.YahooMailClassic@web29013.mail.ird.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 05.04.2012, 17:45 +0100 schrieb Paul Parsons:
> This patch is part of a set which adds PCMCIA/CF support for the hx4700.
> This patch adds asic3_set_register() calls to:
> 1. Enable the PCMCIA/CF in asic3_probe().
> 2. Disable the PCMCIA/CF in asic3_remove().
> 
> Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
> Cc: Philipp Zabel <philipp.zabel@gmail.com>

Acked-by: Philipp Zabel <philipp.zabel@gmail.com>

regards
Philipp


