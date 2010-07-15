Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab0GOLvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 07:51:11 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:49835 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758214Ab0GOLvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 07:51:09 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jul 2010 07:51:08 EDT
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX1/XpnMDdu3Xus13wqxzI2nOuMoLDpciriR+uXBo5/
	lMuMcz0BVUY86d
Date: Thu, 15 Jul 2010 14:46:48 +0300 (EEST)
From: Dimitrios Apostolou <jimis@gmx.net>
X-X-Sender: jimis@localhost.localdomain
To: Theodore Tso <tytso@MIT.EDU>
cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        Dan Nicolaescu <dann@gnu.org>, Teemu Likonen <tlikonen@iki.fi>
Subject: Re: emacs and "linux" coding style
In-Reply-To: <0A4C5074-D482-42EE-98D1-93C636BC80B8@mit.edu>
Message-ID: <alpine.LNX.2.00.1007151432460.1500@localhost.localdomain>
References: <alpine.LNX.2.00.1007131644180.1500@localhost.localdomain> <20100713151902.ca37fc2b.rdunlap@xenotime.net> <0A4C5074-D482-42EE-98D1-93C636BC80B8@mit.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 14 Jul 2010, Theodore Tso wrote:
> I've always read indentation as referring to indentation for the beginning of
> code lines, but not to making function parameters or paraenthesis line
> up.   This is something which emacs does automatically, but vi does not.
>
> People who are anal enough to worry about this sort of thing, in general,
> IMHO, really should find better things to do.   And if checkpatch.pl were to
> be "improved" to start issue warnings about code not adhering to this
> CodingStyle assertion, #1, you would find out how much code doesn't
> adhere to this, and #2, I think a lot of people, including myself, would be
> complaining vociferously and agitating to have that language removed
> from CodingStyle as being an actively harmful and incorrect recommendation.

if two kernel developers agree that tabs-only alignment of arglists is not 
necessary, then my guess is that the CodingStyle document is broken and 
needs to be fixed. Quote from Documentation/CodingStyle:


That's OK, we all do.  You've probably been told by your long-time 
Unix user helper that "GNU emacs" automatically formats the C sources for 
you, and you've noticed that yes, it does do that, but the defaults it 
uses are less than desirable (in fact, they are worse than random typing - 
an infinite number of monkeys typing into GNU emacs would never make a 
good program).

So, you can either get rid of GNU emacs, or change it to use saner
values.  To do the latter, you can stick the following in your .emacs 
file:


If emacs' style is OK then why all this inflamatory talk is needed, and 
why is a patch proposed? The only thing needed is to use the "linux" 
c-style.


Thanks,
Dimitris


P.S. CC'd the author of latest emacs-related patch in CodingStyle
