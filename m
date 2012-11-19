Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab2KSH6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 02:58:00 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49161 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab2KSH57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 02:57:59 -0500
Date: Sun, 18 Nov 2012 23:54:49 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Qing Xu <qingx@marvell.com>
Cc: dwmw2@infradead.org, sameo@linux.intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, haojian.zhuang@gmail.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v3 4/7] mfd: max8925: support dt for power supply
Message-ID: <20121119075448.GA12333@lizard>
References: <1353310752-13212-1-git-send-email-qingx@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353310752-13212-1-git-send-email-qingx@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 03:39:12PM +0800, Qing Xu wrote:
> From: Qing Xu <qingx@marvell.com>

JFYI, I added the following text:

 This patch adds support for initializing platform data from the
 device-tree description.

Plus added <linux/of.h> include.

> Signed-off-by: Qing Xu <qingx@marvell.com>
> ---

Applied, thank you!
