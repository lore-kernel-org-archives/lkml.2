Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2CLR7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:59:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42624 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab2CLR7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:59:32 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V6 2/3] gpio: Add support for Intel ICHx/3100/Series[56] GPIO
To: Aaron Sierra <asierra@xes-inc.com>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter@roeck-us.net>
Cc: Peter Tyser <ptyser@xes-inc.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <886b8cc4-caed-4bce-aa48-9f3181ba09ad@zimbra>
References: <886b8cc4-caed-4bce-aa48-9f3181ba09ad@zimbra>
Date: Mon, 12 Mar 2012 11:59:27 -0600
Message-Id: <20120312175927.19EE33E07B0@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2012 11:41:38 -0600 (CST), Aaron Sierra <asierra@xes-inc.com> wrote:
> From: Peter Tyser <ptyser@xes-inc.com>
> 
> This driver works on many Intel chipsets, including the ICH6, ICH7,
> ICH8, ICH9, ICH10, 3100, Series 5/3400 (Ibex Peak), Series 6/C200
> (Cougar Point), and NM10 (Tiger Point).
> 
> Additional Intel chipsets should be easily supported if needed, eg the
> ICH1-5, EP80579, etc.
> 
> Tested on QM67 (Cougar Point), QM57 (Ibex Peak), 3100 (Whitmore Lake),
> and NM10 (Tiger Point).
> 
> Includes work from Jean Delvare:
> 	- Resource leak removal during module load/unload
> 	- GPIO API bit value enforcement
> 
> Also includes code cleanup from Guenter Roeck and Grant Likely.
> 
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> Signed-off-by: Aaron Sierra <asierra@xes-inc.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

It looks like this depends on the mfd patch for the header file, so this should
be merged via the mfd tree.

g.

> ---
>  MAINTAINERS             |    6 +
>  drivers/gpio/Kconfig    |   13 ++
>  drivers/gpio/Makefile   |    1 +
>  drivers/gpio/gpio-ich.c |  419 +++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 439 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/gpio/gpio-ich.c
> 
