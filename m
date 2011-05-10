Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1EJDLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 23:11:30 -0400
Received: from mail.perches.com ([173.55.12.10]:1429 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab1EJDL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 23:11:29 -0400
Subject: Re: [PATCH]Add Maintainer for MAINTAINERS file for us
From: Joe Perches <joe@perches.com>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>
Cc: linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
        linux-doc@vger.kernel.org, greg@kroah.com, randy.dunlap@oracle.com,
        akpm@linux-foundation.org
In-Reply-To: <20110510025024.GA2575@gmail.com>
References: <20110510025024.GA2575@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 20:11:27 -0700
Message-ID: <1304997087.19586.102.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 10:50 +0800, Harry Wei wrote:
> I'd like to maintain this file for us. The patch is below.

Knock yourself out, but I think this won't
be too valuable.

I suggest you setup a git tree and create a
separate MAINTAINERS section entry and not use
the existing DOCUMENTATION section entry.

Part of handling MAINTAINERS is understanding
that any tree where you collect entries will
not be authoritative.  Lots of other MAINTAINERS
updates will occur outside of your tree and
nothing you do should hinder these updates.

One idea could be to separate all MAINTAINERS
sections into separate files in perhaps
a Maintainers directory.  You would not ever
have to alphabetize sections again.

Maybe add a little script to the Makefile to
aggregate them together as well.

Another would be to add a '*...' pattern type
to the files to match files in any directory
or add a new filename only pattern akin to
'find -name "pattern"' rather than specify both
the directory and file together.

Update scripts/get_maintainer.pl too if you
add some new file pattern types please.

