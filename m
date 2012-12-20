Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab2LTPa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 10:30:57 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57024 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2LTPau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 10:30:50 -0500
From: Federico Vaga <federico.vaga@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] spidev.c: add sysfs attributes for SPI configuration
Date: Thu, 20 Dec 2012 16:30:36 +0100
Message-ID: <1440955.3UsNh3CGzX@number-5>
User-Agent: KMail/4.9.4 (Linux/3.6.10-2.fc17.x86_64; KDE/4.9.4; x86_64; ; )
In-Reply-To: <20121219150925.8262E3E0AD7@localhost>
References: <1353777608-24934-1-git-send-email-federico.vaga@gmail.com> <20121219150925.8262E3E0AD7@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 December 2012 15:09:25 Grant Likely wrote:
> Not a good idea. sysfs is not a good place for operational
> interfaces. Please use the spi character devices for direct
> manipulation of the SPI configuration.

Hello,

Can you explain why it is not a good idea? I do not understand; what 
is the advantage of ioctl through char device? Or what it the issue 
with sysfs?

Thank you very much


-- 
Federico Vaga
