Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab2CSRX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:23:56 -0400
Received: from imr4.ericy.com ([198.24.6.9]:40881 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385Ab2CSRXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:23:55 -0400
Message-ID: <1332177733.32717.158.camel@groeck-laptop>
Subject: Re: [PATCH] gpio: add support for ITE IT87xx Super I/O GPIO.
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Diego Elio =?ISO-8859-1?Q?Petten=F2?= <flameeyes@flameeyes.eu>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Denis Turischev <denis@compulab.co.il>
Date: Mon, 19 Mar 2012 10:22:13 -0700
In-Reply-To: <1332176048.22775.86.camel@saladin.home.flameeyes.eu>
References: <1331927293-17911-1-git-send-email-flameeyes@flameeyes.eu>
	 <20120317123151.AAF9A3E0952@localhost>
	 <1332010422.22775.76.camel@saladin.home.flameeyes.eu>
	 <CACRpkdb4PbZWm8vCaC0MO0a=K+0ZBDhmvoRrTtKXqEy-Jz-VWQ@mail.gmail.com>
	 <20120319005406.GA28497@ericsson.com>
	 <1332172876.22775.84.camel@saladin.home.flameeyes.eu>
	 <1332175414.32717.154.camel@groeck-laptop>
	 <1332176048.22775.86.camel@saladin.home.flameeyes.eu>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 12:54 -0400, Diego Elio Pettenò wrote:
> Il giorno lun, 19/03/2012 alle 09.43 -0700, Guenter Roeck ha scritto:
> > 
> > 
> > Hmm - at least the GPIO part seems to be quite different to IT8721F
> > after all. Too bad that ITE is so restrictive about their datasheets.
> > I
> > hope the differences don't affect hwmon functionality - so far we
> > assume
> > that it is compatible to IT8721F. 
> 
> I plan on taking a look at this at some point; it's not critical for the
> job I'm working on right now, as we're not keeping the temperatures
> under control, but I have the datasheet and I can compare.
> 
> For what it's worth, `sensors` works fine.
> 
Good to know. I am more concerned about fan control, though. Some of the
fan control pins are multiplexed with GPIO pins, and from your feedback
it is possible if not likely that the code used to detect the
configuration is wrong.

Thanks,
Guenter


