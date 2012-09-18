Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab2IRA6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 20:58:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43335 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2IRA6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 20:58:42 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1347898641-17575-1-git-send-email-apr@cn-eng.de>
References: <1347898641-17575-1-git-send-email-apr@cn-eng.de>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 18 Sep 2012 08:58:22 +0800
Message-ID: <CAF+7xW=PBGNbDRGmWyJR=e1OaxN4C85hTywKiyytB3pq6ST8cA@mail.gmail.com>
Subject: Re: [PATCH] mfd: Use devm_* APIs for mc13xxx: remove leftover kfree
To: Andreas Pretzsch <apr@cn-eng.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/18 Andreas Pretzsch <apr@cn-eng.de>:
> commit e7c706b1e5ccf28eaaf76c7a4613e80b0ca52863 migrated the allocation
> of struct mc13xxx to devm_* functions, but left a kfree(mc13xxx) in the
> mc13xxx_common_init error path. Remove it to prevent memory corruption.
>
> Signed-off-by: Andreas Pretzsch <apr@cn-eng.de>

Reviewed-by: Axel Lin <axel.lin@gmail.com>
