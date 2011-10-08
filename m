Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab1JHVGn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 17:06:43 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:45265 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab1JHVGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 17:06:42 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Valdis.Kletnieks@vt.edu, Adrian Bunk <bunk@stusta.de>,
        "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
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
	<14191.1317930659@turing-police.cc.vt.edu>
	<m34nzlbwbi.fsf@intrepid.localdomain>
	<15324.1318004954@turing-police.cc.vt.edu>
	<1318050133.19519.184.camel@constitution.bos.jonmasters.org>
	<58779.1318084612@turing-police.cc.vt.edu>
	<1318096788.19519.187.camel@constitution.bos.jonmasters.org>
Date: Sat, 08 Oct 2011 23:06:39 +0200
In-Reply-To: <1318096788.19519.187.camel@constitution.bos.jonmasters.org> (Jon
	Masters's message of "Sat, 08 Oct 2011 13:59:48 -0400")
Message-ID: <m3mxdbxkf4.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters <jonathan@jonmasters.org> writes:

> One reason I stopped doing keysigning parties is that I
> realized they were mostly a show. You turn up and get a key signed and
> then everyone is impressed that you're in the strong set...wupdedoo.

I think there are other weaknesses than those. Examples:
- people checking the fingerprints on the keyserver, then getting the
  keys later and signing without checking the fingerprints again (the
  fingerprint may "change"),
- people sending the public key through email etc., and signing the key
  without checking (the key may change in email).

Especially in a situation like this one, when a key signing activity is
expected, people MUST check the fingerprint against the authenticated
one WHILE signing the key. It's probably more important that the very
careful check of ID authenticity (watermarks etc).

I'd be only a little surprised if some key signing fraud resulting in
kernel.org access attempt or something similar is detected soon.

> Not
> that I've anything against signing stuff on kernel.org and trying to
> improve things (I've long directly signed everything on master with my
> own keys in slight violation of policy, but that turned out to right).

At first I thought you meant signing with your private key on master :-)
-- 
Krzysztof Halasa
