Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab0IJJxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:53:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40316 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab0IJJxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:53:11 -0400
Date: Fri, 10 Sep 2010 10:53:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: florian@mickler.org, Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
	default
Message-ID: <20100910095259.GC23903@sirena.org.uk>
References: <1284111212-10659-1-git-send-email-florian@mickler.org> <1284111767.1783.35.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284111767.1783.35.camel@Joe-Laptop>
X-Cookie: Here there be tygers.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 02:42:47AM -0700, Joe Perches wrote:

> As the coverage of file patterns in MAINTAINERS is
> now pretty good, the --git results are less useful.

It's pretty good for subsystems and PC drivers but for embedded stuff it
is much more patchy and fairly unlikely to find someone who actually
knows about the specific hardware.

> I'd much rather turn off --git as a default, or change
> get_maintainers to add git signers only when there's no
> specifically listed maintainer for a particular file.

OTOH I'd still be somewhat in favour of this purely on the basis that
the default results have way too many false positives.
