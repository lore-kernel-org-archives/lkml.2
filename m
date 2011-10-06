Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965233Ab1JFRkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:40:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54322 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965182Ab1JFRkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:40:11 -0400
Date: Thu, 6 Oct 2011 18:39:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Valdis.Kletnieks@vt.edu, Adrian Bunk <bunk@stusta.de>,
        "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111006173940.GF12975@sirena.org.uk>
References: <4E8655CD.90107@zytor.com>
 <201110020304.28288.rjw@sisk.pl>
 <4E87B885.50005@zytor.com>
 <201110021354.57995.rjw@sisk.pl>
 <4E88A537.4010008@zytor.com>
 <20111003093239.GB25136@localhost.pp.htv.fi>
 <y0mobxyjazi.fsf@fche.csb>
 <20111003180441.GD3072@localhost.pp.htv.fi>
 <34045.1317760188@turing-police.cc.vt.edu>
 <1317916702.19519.1.camel@constitution.bos.jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317916702.19519.1.camel@constitution.bos.jonmasters.org>
X-Cookie: ((lambda (foo) (bar foo)) (baz))
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 11:58:22AM -0400, Jon Masters wrote:

> What I'd like to see is "keysigning" parties where folks with well
> established (in use) keys turn up and *prove* they own the key by
> signing some information the other attendees provide. That way they can
> not only say "hey, I'm dude X, trust me this is my fingerprint, here's a
> photo ID" (which means nothing in the case of a well established online
> identify that is trusted already), but they can say "hey, I have access
> to this key, because I just signed that random message you gave me
> interactively". Who cares who the heck they really are beyond that?
> (intentionally a loaded statement to make the point).

A common approach to this for at least the e-mail portion of the address
is to sign the ID with the address and then mail the signed key
encrypted to the address, deleting all local copies and requiring that
the recipient publish the signature.  This at least demonstrates that
the owner of the key can read mail at that address.
