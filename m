Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab1HLHAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 03:00:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36437 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab1HLG76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 02:59:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: LPC2011 Power Management Micro Conf
Date: Fri, 12 Aug 2011 09:01:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arjan van de Ven <arjan@infradead.org>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Paul Walmsley <paul@pwsan.com>,
        LKML <linux-kernel@vger.kernel.org>, Jean Pihet <j-pihet@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Len Brown <lenb@kernel.org>,
        tytso@mit.edu
References: <201105011353.44809.rjw@sisk.pl> <201107030929.28555.rjw@sisk.pl> <20110812033221.GA5671@sirena.org.uk>
In-Reply-To: <20110812033221.GA5671@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108120901.37632.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 12, 2011, Mark Brown wrote:
> On Sun, Jul 03, 2011 at 09:29:28AM +0200, Rafael J. Wysocki wrote:
> 
> > If there's anything you'd like to discuss or give a presentation on related to
> > Power Management, please let me know, preferably by replying to this message.
> 
> The issue of cross-bus sequencing within suspend has come up again - we
> really need to work out how we make sure that dependencies between
> devices that aren't accounted for in the control bus sorting we do as
> standard.  This may be worth bringing up a KS also as it's device model
> related.

I agree, I'll add it to the agenda of the LPC microconf.

Thanks,
Rafael
