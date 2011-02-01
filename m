Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab1BAME5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 07:04:57 -0500
Received: from lechat.rtp-net.org ([88.191.19.38]:57820 "EHLO
	lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab1BAME4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 07:04:56 -0500
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>, liu.y.victor@gmail.com,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, B02280@freescale.com
Subject: Re: [PATCH 3/9] Add a mfd IPUv3 driver
Organization: RtpNet
References: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
	<1292842127-21406-4-git-send-email-s.hauer@pengutronix.de>
	<20110201105127.GA10128@sortiz-mobl>
	<20110201105909.GS9041@pengutronix.de>
	<20110201114453.GC10128@sortiz-mobl>
	<20110201115125.GE31216@n2100.arm.linux.org.uk>
Date: Tue, 01 Feb 2011 13:07:35 +0100
In-Reply-To: <20110201115125.GE31216@n2100.arm.linux.org.uk> (Russell King's
	message of "Tue, 1 Feb 2011 11:51:25 +0000")
Message-ID: <87wrlkyn3s.fsf@lechat.rtp-net.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Tue, Feb 01, 2011 at 12:44:54PM +0100, Samuel Ortiz wrote:
>> Ok, so would moving it do drivers/video/ make sense ?
>
> Isn't that for framebuffer drivers?

For now, the ipu driver is used for framebuffer on imx5.

Arnaud
