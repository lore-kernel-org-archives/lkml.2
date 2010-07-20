Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab0GTQD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 12:03:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752050Ab0GTQD4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 12:03:56 -0400
MIME-Version: 1.0
In-Reply-To: <4C45C33C.9090907@oracle.com>
References: <20100719181240.fc3066cd.randy.dunlap@oracle.com>
	<AANLkTilwV9PPdpM5JZ65M_TYr_XfVDBHCLXLJVYkTEav@mail.gmail.com>
	<4C45C33C.9090907@oracle.com>
Date: Tue, 20 Jul 2010 08:56:53 -0700
Message-ID: <AANLkTilwwEklGyp1Nu8tx7wxu1pDeJkEZ1vaa3E18j32@mail.gmail.com>
Subject: Re: [git pull v2] documentation: fix almost duplicate filenames 
	(io/IO-mapping.txt)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Kees Bakker <kees.bakker@xs4all.nl>,
        Keith Packard <keithp@keithp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 8:39 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
>    Subject: documentation: fix almost duplicate filenames (IO/io-mapping.txt)
>    From: Randy Dunlap <randy.dunlap@oracle.com>

This is still wrong.

The commit message should not have email headers, and it shouldn't
have a From: in it. The authorship (and committer) information is
separate to the message, so the message _should_ look just something
like:

    documentation: fix almost duplicate filenames (IO/io-mapping.txt)

    Having both IO-mapping.txt and io-mapping.txt in Documentation/
    was confusing and/or bothersome to some people, so rename
    IO-mapping.txt to bus-virt-phys-mapping.txt.  Also update
    Documentation/00-INDEX for both of these files.

    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

and nothing else.

Try using "gitk" on your tree, you'll see how it looks. The first line
is always used as a summary of the whole thing, which is why you want
a single line that describes the thing, and then an empty line,
followed by the more complete description.

The "From: " and "Subject: " lines are just for _emails_ - various git
tools will take an email, and use that email to fill in the commit
information correctly (ie the "Subject:" line of an email becomes that
first summary line, and the "From:" line becomes authorship). But when
you edit the messages directly, don't use those things.

(If you want to set author information that isn't yourself, you'd use
'git commit --author="xyz <xyz@example.com>"' etc, but normally you'd
never need that, since normally if you do "git commit" you're
obviously committing your own work).

              Linus

                 Linus
