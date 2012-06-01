Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965142Ab2FAP4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:56:35 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60199 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965027Ab2FAP4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:56:31 -0400
Date: Fri, 1 Jun 2012 15:58:48 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Philipp Riemer <ruderphilipp@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Paul Mundt <lethal@linux-sh.org>,
        Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Wang Chen <ellre923@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] new mailmap file for the linux kernel git repository
Message-ID: <20120601075848.GB9920@kroah.com>
References: <CAFU-uVs_Gwacxj74cyekY2gv+zAq+Spba7nfPLdTc_dR3y8CYw@mail.gmail.com>
 <20120516143830.GA483@kroah.com>
 <alpine.LNX.2.00.1205161640520.8796@pobox.suse.cz>
 <CAFU-uVt94sgzq7DgsgKL2OJ0e7DazvNpFunx7BNEz88LHJOg+g@mail.gmail.com>
 <20120516150813.GA3293@kroah.com>
 <CAFU-uVvzyN0asmReOVJcAEiAtbQ=styfGxRRbnrJKgNFDS5X_g@mail.gmail.com>
 <CAFU-uVsStG0KoiQm95-uC8ZPXWAq=8Q8vXircxOuUCHhk+r9uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFU-uVsStG0KoiQm95-uC8ZPXWAq=8Q8vXircxOuUCHhk+r9uw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 06:08:48PM +0200, Philipp Riemer wrote:
> updated mailmap file for LK repository
> 
> The current version of the .mailmap file does only capture a fraction of errors
> and ambiguity when looking at developers emails and names. Hence, this revised
> version tries to address many more names and, as a result, to clarify maintainer
> information. Issues addressed:
>  - Typos in names
>  - Typos in mails
>  - Mapping of ambiguous mail adresses (e.g. {aa@bb.cc, aa@home.(none),
>    aa@laptop.bb.cc,...} becomes {aa@bb.cc}) but keeping LKML specific ones
>  - Mapping of names to entries with only email information
>  - Correct usage of special character (e.g. German umlauts)
>  - Harmonization of position and style of last name (no more all-caps names
>    like "First LAST" or those of "Last, First")
>  - No initials in names if not necessary
>  - Conversion of email addresses to lower case
> 
> Signed-off-by: Philipp Riemer <ruderphilipp@gmail.com>
> ---
> Finally I am back from my trip through Germany and after attending
> LinuxTag in Berlin last week, reading Documentation/SubmittingPatches,
> and checking other patch submissions, I give this topic finally a new
> try...  Hopefully my submission confirms to the LK standards this
> time. I can certify that this contribution was conscientiously created
> in whole by me and therefore added the sign-off message.
> 
> Please pull from
> 
> 		git://github.com/ruderphilipp/linux.git mailmap-changes
> 
> to get the changes in the attached patch file (since even the
> web-interface of GMail wraps lines) -- or simply inspect/apply that
> file directly.
> 
> $ git diffstat upstream/master..origin/mailmap-changes .mailmap
>  .mailmap | 2482 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 2444 insertions(+), 38 deletions(-)

Where did you get some of these email addresses from?  My "kroah.org"
entries never showed up in the kernel commit logs, nor are they valid email
addresses, so why did you add them to the file?

greg k-h
