Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab2D3Jd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 05:33:58 -0400
Received: from senator.holtmann.net ([87.106.208.187]:56152 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133Ab2D3Jd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 05:33:57 -0400
Message-ID: <1335778393.5970.9.camel@aeonflux>
Subject: Re: [PATCH 1/1] bluetooth: Add support for Foxconn/Hon Hai AR5BBU22
 0489:E03C
From: Marcel Holtmann <marcel@holtmann.org>
To: Michael =?ISO-8859-1?Q?Gr=FCtzner?= <mgruetzn@gmx.de>
Cc: gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 30 Apr 2012 11:33:13 +0200
In-Reply-To: <1844233.LmPXZadnGE@dagobah>
References: <1844233.LmPXZadnGE@dagobah>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

> Add Foxconn/Hon Hai AR5BBU22 Bluetooth Module( 0x489:0xE03C) to 
> the blacklist of btusb module and add it to the ath3k module to properly load 
> the firmware in Kernel 3.3.4
> The device is integrated in  e.g. some  Acer Aspire 7750G.

please include the details from /sys/kernel/debug/usb/devices for the
different modes of this device in the commit message. We need to keep a
record of these.

Regards

Marcel


