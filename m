Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab2EPOig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:38:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49857 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2EPOif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:38:35 -0400
Date: Wed, 16 May 2012 07:38:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Philipp Riemer <ruderphilipp@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Wang Chen <ellre923@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [GIT PULL] new mailmap file for the linux kernel git repository
Message-ID: <20120516143830.GA483@kroah.com>
References: <CAFU-uVs_Gwacxj74cyekY2gv+zAq+Spba7nfPLdTc_dR3y8CYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFU-uVs_Gwacxj74cyekY2gv+zAq+Spba7nfPLdTc_dR3y8CYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 04:25:28PM +0200, Philipp Riemer wrote:
> Dear members of the LKML,
> I spent the last weeks creating a new .mailmap file for the LK git
> repo (see previous mail attached below).
> 
> The new version of this file is available in the git repository at:
>   git://github.com/ruderphilipp/linux.git mailmap-changes
> 
> Latest commit at the branch: 5b4e7ca5d453bc2701ef79969aecb9ed23abd469
> mailmap changes
> The following changes since commit 36be50515fe2aef61533b516fa2576a2c7fe7664
>  .mailmap | 2479 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 2441 insertions(+), 38 deletions(-)
> 
> Patch file in addition below the attached mail.
> 
> In my work I considered the following aspects:
> * Typos in names
> * Typos in mails
> * Mapping of ambiguous mail adresses (e.g. {aa@bb.cc, aa@home.bb.cc,
> aa@laptop.bb.cc,...} becomes {aa@bb.cc})
> * Mapping of names to entries with only email information
> * Harmonization of position and style of last name (no more all-caps
> names like "First LAST" or those of "Last, First")
> * No initials in names if not necessary
> * Conversion of email addresses to lower case
> 
> Why did I do this? One reason for that is a missing configuration of
> Git -- leading to a combination of the name of user (login) and
> computer (e.g. "me@mybox.local"). Of course this is not a real mail
> address and most users realize and fix this fact pretty fast.
> Nevertheless there is at least one commit with wrong data in the
> codebase. Another reason is spelling. When skimming through the vast
> list of author names and email addresses one can find many
> typographical errors such as ".con" instead of ".com" or missing
> letters. Over time also these get fixed -- but the wrong data is
> visible.
> 
> I am pretty confident that I coalesced the data of most of the
> ambiguous users. But despite having spent so many hours in finding and
> matching these entries, this work (that I did primarily for my thesis)
> might be helpful for other researchers as well, such as e.g. Wang Chen
> as the maintainer of the Linux Kernel Patch Statistic
> <http://www.remword.com/kps_result/> or Greg, Jonthan, etc. as the
> authors of "Who writes Linux"
> <http://go.linuxfoundation.org/who-writes-linux-2012>...
> 
> Hence, please integrate this file into the official Linux Kernel repository.

You forgot a signed-off-by: line which is required for a patch to be
accepted :(

