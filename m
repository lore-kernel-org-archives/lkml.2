Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab2IKSaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:30:13 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:44311 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758372Ab2IKSaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:30:09 -0400
Date: Tue, 11 Sep 2012 20:29:12 +0200
From: Alessandro Rubini <rubini@unipv.it>
To: arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linus.walleij@linaro.org,
        STEricsson_nomadik_linux@list.st.com, srinidhi.kasagar@stericsson.com,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        dmitry.torokhov@gmail.com, dwmw2@infradead.org, balbi@ti.com,
        gregkh@linuxfoundation.org, andreas.westin@stericsson.com
Subject: Re: [PATCH 12/16] ARM: nomadik: move platform_data definitions
Message-ID: <20120911182912.GA464@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <1347368390-31252-12-git-send-email-arnd@arndb.de>
References: <1347368390-31252-12-git-send-email-arnd@arndb.de>
  <1347368350-31212-1-git-send-email-arnd@arndb.de>
  <1347368390-31252-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Platform data for device drivers should be defined in
> include/linux/platform_data/*.h, not in the architecture
> and platform specific directories.
> 
> This moves such data out of the nomadik include directories

Acked-by: Alessandro Rubini <rubini@unipv.it>

