Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1HNBBk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 21:01:40 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48583 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab1HNBBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 21:01:38 -0400
Date: Sat, 13 Aug 2011 18:01:23 -0700 (PDT)
Message-Id: <20110813.180123.46722618651238324.davem@davemloft.net>
To: jwboyer@redhat.com
Cc: oliver@neukum.org, alexey.orishko@stericsson.com, gregkh@suse.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4] usbnet/cdc_ncm: Don't use stack variables for DMA
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110808123406.GA2526@zod.bos.redhat.com>
References: <20110808123406.GA2526@zod.bos.redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 13 Aug 2011 18:01:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>
Date: Mon, 8 Aug 2011 08:34:07 -0400

> The cdc_ncm driver still has a few places where stack variables are
> passed to the cdc_ncm_do_request function.  This triggers a stack trace in
> lib/dma-debug.c if the CONFIG_DEBUG_DMA_API option is set.
> 
> Adjust these calls to pass parameters that have been allocated with
> kzalloc.
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>

Applied.
