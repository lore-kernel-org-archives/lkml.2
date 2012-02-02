Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab2BBVcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:32:15 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:54679 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932183Ab2BBVcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:32:14 -0500
Message-ID: <1328218327.18641.59.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across lines
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 02 Feb 2012 13:32:07 -0800
In-Reply-To: <20120202212840.GB11308@leaf>
References: <20120202200621.GB9279@leaf>
	 <1328214989.18641.54.camel@joe2Laptop> <20120202212840.GB11308@leaf>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-02 at 13:28 -0800, Josh Triplett wrote:
> On Thu, Feb 02, 2012 at 12:36:29PM -0800, Joe Perches wrote:
> > On Thu, 2012-02-02 at 12:06 -0800, Josh Triplett wrote:
> > > Documentation/CodingStyle recommends not splitting quoted strings across
> > > lines, because it breaks the ability to grep for the string.  checkpatch
> > > already makes an exception to the 80-column rule for quoted strings to
> > > allow this.  Rather than just allowing it, actively warn about quoted
> > > strings split across lines.
[]
> > Seems sensible but there are also asm uses like:
> > arch/x86/include/asm/pvclock.h:         "xor  %5,%5    ; "
> >                 "add  %4,%%eax ; "
> I did see those, yes.  However, a quick grep through the kernel shows
> that those occur quite rarely compared to \n or \n\t; the latter looks
> like the standard style.  How about I provide a patch for
> Documentation/CodingStyle adding a chapter on inline assembly, with that
> and other style guidelines? :)

Sounds fine to me.

Another option might be to ignore all
strings in any asm block.


