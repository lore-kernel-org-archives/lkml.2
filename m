Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564Ab0I0UIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 16:08:21 -0400
Received: from mail.perches.com ([173.55.12.10]:2478 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619Ab0I0UIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 16:08:19 -0400
Subject: Re: RFC: get_maintainer.pl: append reason for cc to the name by
 default
From: Joe Perches <joe@perches.com>
To: Florian Mickler <florian@mickler.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20100927212650.62859ee0@schatten.dmk.lab>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	 <1285527125.1732.24.camel@Joe-Laptop>
	 <20100927165748.354742f2@schatten.dmk.lab>
	 <20100927154441.GE3602@thunk.org>
	 <20100927190026.20ddc268@schatten.dmk.lab>
	 <20100927182124.GA3168@thunk.org>
	 <20100927212650.62859ee0@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 13:08:17 -0700
Message-ID: <1285618097.1732.204.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 21:26 +0200, Florian Mickler wrote:
> But we should definitely try to tune down the annoying part of
> it by making it less random and maybe by adding a tag in the cc field...

Less random: sure, whatever's reasonable.

I still think that tagging the name portion of an email address
is not a good idea, especially without some way of turning it
off.  Maybe a mechanism to optionally enable it would be ok.

