Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab2DXGKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 02:10:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35580 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab2DXGKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 02:10:35 -0400
Date: Tue, 24 Apr 2012 01:10:27 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Marc Kleine-Budde <mkl@blackshift.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/2] ARM: ixp4xx: fix compilation, add gpiolib support
Message-ID: <20120424061027.GA23859@burratino>
References: <1328729069-21308-1-git-send-email-mkl@blackshift.org>
 <1328729069-21308-2-git-send-email-mkl@blackshift.org>
 <20120412052518.GA3260@netboy.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412052518.GA3260@netboy.at.omicron.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Cochran wrote:
> On Wed, Feb 08, 2012 at 08:24:28PM +0100, Marc Kleine-Budde wrote:

>> From: Imre Kaloz <kaloz@openwrt.org>
>>
>> The problem was introduced with commit:
>> "eb9ae7f gpio: fix build error in include/asm-generic/gpio.h"
>>
>> This patch adds gpiolib support for the IXP4xx platform, which fixes the
>> compilation of several ixp4xx platforms, e.g.:
>
> Sorry to nag, but is someone going to take this patch?

It looks like Russell's question[*] was never answered:

| Does anything on ixp4xx require fast access to on-chip GPIOs?  If not,
| it would be much better to get rid of this and just use the standard
| wrapping, which can be done by changing this entire file to be just a
| single line:

Hope that helps,
Jonathan

[*] http://thread.gmane.org/gmane.linux.kernel/1250585/focus=1250908
