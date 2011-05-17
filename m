Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab1EQUXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 16:23:36 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:61745 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab1EQUXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 16:23:35 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4DD2D937.7070803@ise.pw.edu.pl>
Date: Tue, 17 May 2011 22:23:19 +0200
From: wzab <wzab@ise.pw.edu.pl>
Reply-To: wzab@ise.pw.edu.pl
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Reuse of spi_transfer and spi_message structures for cyclic communication
 with SPI devices?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm writing a device driver for data acquisition system using A/D
converters connected via SPI interface.
To allow flexible ordering of received data, the content
of spi_transfer structures ans spi_message structures
must be set-up in quite sophisticate way before the transfer
may be started.
Refilling of those structures in each sampling cycle will be very
time consuming. I'd prefer to reuse the same structures again and
again, but I can't find any info in the kernel if I'm allowed to.

The documentation suggests to zero spi_transfer ans spi_message
before filling, but doesn't state if they may be used multiple times
with the same I/O buffers without zeroing and refilling.
-- 
TIA & Regards,
Wojtek Zabolotny

