Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab0FWXas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 19:30:48 -0400
Received: from mail.perches.com ([173.55.12.10]:1268 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab0FWXar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 19:30:47 -0400
Subject: Re: [PATCH] drivers/usb: Remove unnecessary return;s from void
 functions
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1276224993.1556.455.camel@Joe-Laptop.home>
References: <1276224993.1556.455.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Jun 2010 16:30:35 -0700
Message-ID: <1277335835.9699.0.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 19:56 -0700, Joe Perches wrote:
> There are about 2500 void functions in drivers/usb
> Only a few used return; at end of function.
> 
> Standardize them a bit.
> 
> Moved a statement down a line in drivers/usb/host/u132-hcd.c
> 
> Signed-off-by: Joe Perches <joe@perches.com>

ping?


