Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494Ab2DGA2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 20:28:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48565 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758478Ab2DGA2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 20:28:34 -0400
Date: Sat, 7 Apr 2012 01:28:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Keith Packard <keithp@keithp.com>, Ralf Baechle <ralf@linux-mips.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] module: Clarify GPL-Compatible is OK
Message-ID: <20120407002828.GG6589@ZenIV.linux.org.uk>
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 05:11:22PM -0700, Luis R. Rodriguez wrote:

> You do not need to make dual licenses when licenses are compatible
> with each other, and in fact at times this can confuse developers / legal.
> This has been well documented by SFLC through their "Maintaining
> Permissive-Licensed Files in a GPL-Licensed Project: Guidelines for
> Developers" [0] which was inspired by the ambiguity of the MadWifi
> Project's Dual BSD/GPL license tradition. The list of GPL-Compatible
> licenses can be found on the FSF's website [1].

This is obvious crap.  Explain to me, please, what makes your "GPL compatible"
different from "GPLv2"; at least that would be honest ("we have relicensed
a copy of BSD/GPL code to GPL alone - the license allows that and any
modifications done here are declared GPL-only, so you can't pull them into
the BSD-licensed variants")

"GPL compatible" is not a license; it's a set of licenses.  Incidentally,
belonging to that set is irrelevant to legality of including into the kernel,
since GPLv3 a member and it's *NOT* compatible with the kernel license.
since GPLv3 a member and it's *NOT* compatible with the kernel license.
