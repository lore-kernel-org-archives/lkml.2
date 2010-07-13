Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab0GMTtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 15:49:39 -0400
Received: from mail.perches.com ([173.55.12.10]:1863 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756906Ab0GMTti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 15:49:38 -0400
Subject: Re: [PATCH] drivers/usb: Remove unnecessary return;s from void
 functions
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-usb <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1277357408.1654.4.camel@Joe-Laptop.home>
References: <1277357408.1654.4.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jul 2010 12:49:36 -0700
Message-ID: <1279050576.1501.435.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-23 at 22:30 -0700, Joe Perches wrote:
> There are about 2500 void functions in drivers/usb
> Only a few used return; at end of function.
> 
> Standardize them a bit.
> 
> Moved a statement down a line in drivers/usb/host/u132-hcd.c

ping?

