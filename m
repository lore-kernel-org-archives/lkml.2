Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab0DSJXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 05:23:16 -0400
Received: from relay.atmel.no ([80.232.32.139]:61125 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab0DSJXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 05:23:14 -0400
Date: Mon, 19 Apr 2010 11:22:17 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org
Subject: Re: [PATCH] MMC: atmel-mci: enable SD high speed support
Message-ID: <20100419112217.16578d34@hskinnemoen-d830>
In-Reply-To: <1271671952-29204-1-git-send-email-nicolas.ferre@atmel.com>
References: <1271671952-29204-1-git-send-email-nicolas.ferre@atmel.com>
Organization: Atmel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Enable high speed support for atmel-mci driver. This support is dependent of
> the revision of the IP and, of course, the capacity of the SD card used.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Looks good to me.

Reviewed-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
