Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965226Ab1JFRpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:45:49 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:55598 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755803Ab1JFRps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:45:48 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jon Masters <jonathan@jonmasters.org>, Valdis.Kletnieks@vt.edu,
        Adrian Bunk <bunk@stusta.de>, "Frank Ch. Eigler" <fche@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
References: <4E8655CD.90107@zytor.com> <201110020304.28288.rjw@sisk.pl>
	<4E87B885.50005@zytor.com> <201110021354.57995.rjw@sisk.pl>
	<4E88A537.4010008@zytor.com>
	<20111003093239.GB25136@localhost.pp.htv.fi>
	<y0mobxyjazi.fsf@fche.csb> <20111003180441.GD3072@localhost.pp.htv.fi>
	<34045.1317760188@turing-police.cc.vt.edu>
	<1317916702.19519.1.camel@constitution.bos.jonmasters.org>
	<20111006173940.GF12975@sirena.org.uk>
Date: Thu, 06 Oct 2011 19:45:45 +0200
In-Reply-To: <20111006173940.GF12975@sirena.org.uk> (Mark Brown's message of
	"Thu, 6 Oct 2011 18:39:40 +0100")
Message-ID: <m3zkheau9i.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown <broonie@opensource.wolfsonmicro.com> writes:

> A common approach to this for at least the e-mail portion of the address
> is to sign the ID with the address and then mail the signed key
> encrypted to the address, deleting all local copies and requiring that
> the recipient publish the signature.  This at least demonstrates that
> the owner of the key can read mail at that address.

The assumption here is the attacker can read (and write) victim's email.
It's not about verifying email access or address.
-- 
Krzysztof Halasa
