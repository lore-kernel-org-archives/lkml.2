Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab1DKVHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 17:07:50 -0400
Received: from kroah.org ([198.145.64.141]:47236 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910Ab1DKVHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 17:07:10 -0400
Date: Mon, 11 Apr 2011 14:06:31 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        Andy Botting <andy@andybotting.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][PATCH V3] axi: add AXI bus driver
Message-ID: <20110411210631.GA28559@kroah.com>
References: <1302557114-7880-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302557114-7880-1-git-send-email-zajec5@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 11:25:14PM +0200, Rafał Miłecki wrote:
> +static void axi_release_core_dev(struct device *dev)
> +{
> +	/* Silent lack-of-release warning */
> +}

Ok, WTF!!!!

As per the documentation in the kernel I now get to publically mock you
for trying to be smarter than the kernel.  Why did you think that if you
just magically gave an empty function to the kernel it would solve the
problem that THE KERNEL WAS TRYING TO TELL YOU TO FIX IN THE FIRST
PLACE?

{sigh}

It's as if no one reads the documentation, or even pays attention to the
message that the kernel spits out and they think they know better.

Totally and completely unacceptable.

Fix this now.

greg k-h
