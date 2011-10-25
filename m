Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1JYIJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:09:21 -0400
Received: from mail.tnnet.fi ([217.112.240.26]:52909 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab1JYIJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:09:20 -0400
Message-ID: <4EA66EAD.DD69F31C@users.sourceforge.net>
Date: Tue, 25 Oct 2011 11:09:17 +0300
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel.org tarball/patch signature files
References: <4EA3F7C0.24E469C5@users.sourceforge.net>
		 <20111023113727.GA24285@kroah.com>
		 <4EA41FB7.CB5369CF@users.sourceforge.net>
		 <20111025014911.GC22764@kroah.com>
		 <4EA651ED.44FDE737@users.sourceforge.net> <20111025070910.GA9639@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Oct 25, 2011 at 09:06:37AM +0300, Jari Ruusu wrote:
> > How about signing just one compressed tarball/patch, and let other
> > compressed versions be without signature files. Users who want to check
> > signature will then download the one you signed.
> 
> That's no difference from what we are doing today if you think it
> though.

You signing compressed version eliminates exposure to yet undiscovered
decompressor bugs. Pre-emptively removing as many as possible attack
surfaces is the correct securely engineered way of doing things. You signing
decompressed version is opposite of that. You added new attack surface.

Decompressors are complex software. They almost certainly have bugs in
evil-formatted data handling, forever. Reading data from untrusted internet
and feeding that data to decompressor without any authentication, screams
"REMOTE EXPLOIT ME", if you look at it from security point of view.

> Yes, we are working on just that thing, and the foo.tar.sums file will
> be signed with the kernel.org "throwaway" key, so you can check that as
> well.

That sounds much better than current signing practice.

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
