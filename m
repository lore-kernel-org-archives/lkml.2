Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab1EJEwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 00:52:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47110 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1EJEwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 00:52:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=hyKerQkzhAmfAfKQEPnMrxXuA11WioyFeGs4vK/oqbBrj7n8ug/nNrkiQ/TxGlmhpZ
         e2Fj2ZxrnFp53cBFJ8J+6IpUMZ7JkyXbRhwvEZ3lKzFylAAivuZiFzqAQvrUO/8TU53i
         Ie0/+1zWuDPFIuYQ0gm54EZahKaTk3Rtbigdw=
Date: Tue, 10 May 2011 12:51:45 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
        akpm@linux-foundation.org, greg@kroah.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH]Add Maintainer for MAINTAINERS file for us
Message-ID: <20110510045142.GA2888@gmail.com>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
	akpm@linux-foundation.org, greg@kroah.com,
	linux-doc@vger.kernel.org
References: <20110510025024.GA2575@gmail.com>
 <1304997087.19586.102.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <1304997087.19586.102.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 08:11:27PM -0700, Joe Perches wrote:
> On Tue, 2011-05-10 at 10:50 +0800, Harry Wei wrote:
> > I'd like to maintain this file for us. The patch is below.
> 
> Knock yourself out, but I think this won't
> be too valuable.
The patch has been updatated below.
> 
> I suggest you setup a git tree and create a
> separate MAINTAINERS section entry and not use
> the existing DOCUMENTATION section entry.
> 
> Part of handling MAINTAINERS is understanding
> that any tree where you collect entries will
> not be authoritative.  Lots of other MAINTAINERS
> updates will occur outside of your tree and
> nothing you do should hinder these updates.
> 
> One idea could be to separate all MAINTAINERS
> sections into separate files in perhaps
> a Maintainers directory.  You would not ever
> have to alphabetize sections again.
This may a little complex. Keeping just MAINTAINERS file
with alphabetical order is well for us.
I will also write a shell script for MAINTAINERS, which
can not only check whether it is in alphabetical order
but may also take orders for us.
The script is been programing by me and my friend.
When it is okay, i will patch for kernel.
> 
> Maybe add a little script to the Makefile to
> aggregate them together as well.
> 
> Another would be to add a '*...' pattern type
> to the files to match files in any directory
> or add a new filename only pattern akin to
> 'find -name "pattern"' rather than specify both
> the directory and file together.
> 
> Update scripts/get_maintainer.pl too if you
> add some new file pattern types please.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index af39897..629dd7c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4043,6 +4043,12 @@ S:	Maintained
 F:	drivers/net/macvlan.c
 F:	include/linux/if_macvlan.h
 
+MAINTAINERS-FILE
+M:	Harry Wei <harryxiyou@gmail.com>
+L:	linux-doc@vger.kernel.org
+S:	Maintained
+F:	MAINTAINERS
+
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
 M:	Michael Kerrisk <mtk.manpages@gmail.com>
 W:	http://www.kernel.org/doc/man-pages
-- 
1.7.0.4

