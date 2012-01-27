Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab2A0RQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:16:46 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:58630 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751881Ab2A0RQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:16:45 -0500
Message-ID: <1327684589.12089.22.camel@joe2Laptop>
Subject: Re: [PATCH] mtd/nand: use string library
From: Joe Perches <joe@perches.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Jiandong Zheng <jdzheng@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Date: Fri, 27 Jan 2012 09:16:29 -0800
In-Reply-To: <1327674295-3700-2-git-send-email-akinobu.mita@gmail.com>
References: <1327674295-3700-1-git-send-email-akinobu.mita@gmail.com>
	 <1327674295-3700-2-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 23:24 +0900, Akinobu Mita wrote:
> - Use memchr_inv to check if the data contains all 0xFF bytes.
>   It is faster than looping for each byte.

Stupid question:

Are there any mtd devices modified that are slower
at 64 bit accesses than repeated 8 bit accesses?

