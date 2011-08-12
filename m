Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab1HLDcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 23:32:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50691 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab1HLDcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 23:32:42 -0400
Date: Fri, 12 Aug 2011 04:32:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arjan van de Ven <arjan@infradead.org>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Paul Walmsley <paul@pwsan.com>,
        LKML <linux-kernel@vger.kernel.org>, Jean Pihet <j-pihet@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Len Brown <lenb@kernel.org>,
        tytso@mit.edu
Subject: Re: LPC2011 Power Management Micro Conf
Message-ID: <20110812033221.GA5671@sirena.org.uk>
References: <201105011353.44809.rjw@sisk.pl>
 <201107030929.28555.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107030929.28555.rjw@sisk.pl>
X-Cookie: Have you locked your file cabinet?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 03, 2011 at 09:29:28AM +0200, Rafael J. Wysocki wrote:

> If there's anything you'd like to discuss or give a presentation on related to
> Power Management, please let me know, preferably by replying to this message.

The issue of cross-bus sequencing within suspend has come up again - we
really need to work out how we make sure that dependencies between
devices that aren't accounted for in the control bus sorting we do as
standard.  This may be worth bringing up a KS also as it's device model
related.
