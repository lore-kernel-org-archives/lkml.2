Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab2IPVza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 17:55:30 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61646 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2IPVz3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 17:55:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120913083623.GH19497@pengutronix.de>
References: <1297977533-17794-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<20110829190142.GA17354@ponder.secretlab.ca>
	<20120913083623.GH19497@pengutronix.de>
Date: Sun, 16 Sep 2012 23:55:28 +0200
Message-ID: <CACRpkdaOjeRwchGdYbXCh-ZW5ZbxYiBq9+3WGDretqL0Yue5tA@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: add another might_sleep
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 10:36 AM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> Hello,
>
> On Mon, Aug 29, 2011 at 01:01:42PM -0600, Grant Likely wrote:
>> On Thu, Feb 17, 2011 at 10:18:53PM +0100, Uwe Kleine-König wrote:
>> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>>
>> Applied, thanks.
>
> I cannot see it in Linus' tree?!

It's probably because it's in Grant's tree! :-)

Grant, are you up to speed with GPIO again? Shall I send you a pull
request for the stuff I've queued up?

Yours,
Linus Walleij
