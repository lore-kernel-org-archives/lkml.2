Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab2EZPXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 11:23:22 -0400
Received: from antcom.de ([188.40.178.216]:36586 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658Ab2EZPXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 11:23:20 -0400
Message-ID: <4FC0F564.6040609@antcom.de>
Date: Sat, 26 May 2012 17:23:16 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PULL REQUEST] i2c-embedded for 3.5
References: <20120526140650.GA7133@pengutronix.de>
In-Reply-To: <20120526140650.GA7133@pengutronix.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 26/05/12 16:06, Wolfram Sang wrote:
> Note that you will get a trivial merge-conflict because some
> lpc32xx-patches have already come in via arm-soc to reduce dependencies.
> I read that you want to see such conflicts so I didn't take any actions.
> I'll add Arnd and Roland to CC, because they know best about LPC32xx
> changes.

There are already some i2c commits in master that came via arm-soc.
Expect conflicts with some LPC32xx related commits from i2c-embedded.
They are basically the same patches, applied as different commits
though, sorry. But should be easy to resolve.

Roland
