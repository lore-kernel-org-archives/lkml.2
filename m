Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162258Ab2CSQwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:52:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38262 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162218Ab2CSQwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:52:02 -0400
Message-ID: <1332176048.22775.86.camel@saladin.home.flameeyes.eu>
Subject: Re: [PATCH] gpio: add support for ITE IT87xx Super I/O GPIO.
From: Diego Elio =?ISO-8859-1?Q?Petten=F2?= <flameeyes@flameeyes.eu>
To: guenter.roeck@ericsson.com
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Denis Turischev <denis@compulab.co.il>
Date: Mon, 19 Mar 2012 17:54:08 +0100
In-Reply-To: <1332175414.32717.154.camel@groeck-laptop>
References: <1331927293-17911-1-git-send-email-flameeyes@flameeyes.eu>
	 <20120317123151.AAF9A3E0952@localhost>
	 <1332010422.22775.76.camel@saladin.home.flameeyes.eu>
	 <CACRpkdb4PbZWm8vCaC0MO0a=K+0ZBDhmvoRrTtKXqEy-Jz-VWQ@mail.gmail.com>
	 <20120319005406.GA28497@ericsson.com>
	 <1332172876.22775.84.camel@saladin.home.flameeyes.eu>
	 <1332175414.32717.154.camel@groeck-laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il giorno lun, 19/03/2012 alle 09.43 -0700, Guenter Roeck ha scritto:
> 
> 
> Hmm - at least the GPIO part seems to be quite different to IT8721F
> after all. Too bad that ITE is so restrictive about their datasheets.
> I
> hope the differences don't affect hwmon functionality - so far we
> assume
> that it is compatible to IT8721F. 

I plan on taking a look at this at some point; it's not critical for the
job I'm working on right now, as we're not keeping the temperatures
under control, but I have the datasheet and I can compare.

For what it's worth, `sensors` works fine.

-- 
Diego Elio Pettenò — Flameeyes
http://blog.flameeyes.eu/


