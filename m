Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab0JPKdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 06:33:19 -0400
Received: from bay0-omc1-s27.bay0.hotmail.com ([65.54.190.38]:32269 "EHLO
	bay0-omc1-s27.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753040Ab0JPKdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 06:33:18 -0400
X-Originating-IP: [220.255.7.146]
X-Originating-Email: [yifei_wang@hotmail.com]
Message-ID: <BAY158-ds1590A0C95D4EFEDF3B1B5EF5580@phx.gbl>
From: WANG YiFei <yifei_wang@hotmail.com>
To: <linux-kernel@vger.kernel.org>
References: <BAY158-ds58C7B32E913D31188D44FF5540@phx.gbl>
In-Reply-To: <BAY158-ds58C7B32E913D31188D44FF5540@phx.gbl>
Subject: Help about chip select on SPI slave devices
Date: Sat, 16 Oct 2010 18:33:22 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Actput8wevjkZWBUQDexh1Ok4/eTAwDYcnVw
Content-Language: en-sg
X-OriginalArrivalTime: 16 Oct 2010 10:33:18.0048 (UTC) FILETIME=[8BFFFE00:01CB6D1D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have a board which has 1 SPI master controller
and 4 SPI slave devices, and we'd like to use 2
GPIOs to demux to chip select these slave devices.
Can anyone tell me if current powerpc dts support
demuxer for chip select for spi slave devices? So
far as I know, in dts, SPI master can only use 1
to 1 GPIO to CS(then needs 4 GPIOs).


Thanks in advance,
YiFei




