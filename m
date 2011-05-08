Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1EHKR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 06:17:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34150 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1EHKRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 06:17:23 -0400
Date: Sun, 8 May 2011 11:16:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus
	driver
Message-ID: <20110508101609.GF27807@n2100.arm.linux.org.uk>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com> <201105061605.31625.arnd@arndb.de> <BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com> <BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com> <1304790665.13983.10.camel@dev.znau.edu.ua> <BANLkTikLFff_86Fvg+jSty9vGLENiELF2Q@mail.gmail.com> <1304792795.13983.28.camel@dev.znau.edu.ua> <BANLkTi=6BFD4OmtU1WPxjbFJQe36=mZKEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=6BFD4OmtU1WPxjbFJQe36=mZKEA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 07, 2011 at 08:48:10PM +0200, Rafał Miłecki wrote:
> Really, what's wrong with that? Does it kill anyone's pet we print
> this? We also do:
> pr_err("Scanning failed because of wrong CID\n");
> return -1;
> While we could drop pr_err. Why to do this? Advanced used can always
> check what -1 means.

And why return -1 when we have a system of error codes?  I _really_ wish
people would stop returning -1 for "some random error occurred".
