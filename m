Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab2EUQMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 12:12:08 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:26788 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab2EUQMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 12:12:06 -0400
Message-ID: <1337616723.2558.10.camel@lorien2>
Subject: Re: [PATCH] ARM: leds: Add MAX6956 driver
From: Shuah Khan <shuah@fc.hp.com>
Reply-To: shuah@fc.hp.com
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org
Date: Mon, 21 May 2012 10:12:03 -0600
In-Reply-To: <20120521082626.GG3710@pengutronix.de>
References: <1337355945-16421-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <CAK5ve-J8EfvgsO8_RYFub8R1fwBgzkjnq3czECRQzpnpvaXEQw@mail.gmail.com>
	 <20120521082626.GG3710@pengutronix.de>
Organization: ISS-VC
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 10:26 +0200, Uwe Kleine-König wrote:

> > As Shuah said, no kfree(ddata) here
> As Sascha said, it would be wrong to add one.

Thanks. Didn't realize devm_* take care of free at device detach. I am
starting to see patches that make this change to other leds drivers.
Something new to learn. :)

-- Shuah


