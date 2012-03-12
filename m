Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab2CLDnv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 23:43:51 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49496 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab2CLDnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 23:43:46 -0400
MIME-Version: 1.0
Date: Mon, 12 Mar 2012 11:43:45 +0800
Message-ID: <CADvmyBdjTKCj0YfBM2rcqwy80vwNs1wtAXbWMF7cPXm4FZe4kw@mail.gmail.com>
Subject: Could you help on an issue with SPI based on GPIO ?
From: "peter.meng" <mengsanshui@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,

I have a question related SPI .
I used SPI based on GPIO(bitbang) that has MOSI/MISO/CLK/CS  line .
But i found my spi slave device that has a interrupt line .
I want to know how to use GPIO simulate  interrupt on SPI master side  .
How to get the interrupt status from GPIO  and what thing should be
done when interrupt happens ?



Thanks a lot.
Best Regards .
Peter Meng
