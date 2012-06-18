Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab2FRM5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:57:41 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:42405 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab2FRM5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:57:40 -0400
Message-Id: <201206181256.q5ICu2xu011591@sw-eng-lt-dc-vm2>
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Date: Mon, 18 Jun 2012 13:04:29 +0100
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Subject: Re: [PATCH 2/2 v2] regmap: Add support for register indirect addressing.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Applied, thanks.  I had to fix up a few conflicts but I think that's
> done OK, please check though.

It looks fine. Thank you.
I have roughly tested it with I2C device with 8-bit wide address
and it works OK.

I have spotted a bug in the applied paging feature and have provided you
with a patch (to be applied on top of your topic branch).

Kind Regards

