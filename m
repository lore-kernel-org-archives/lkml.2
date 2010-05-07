Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0EGXQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 19:16:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57217 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab0EGXQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 19:16:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull request] ACPI patches for 2.6.34-rc6
Date: Sat, 8 May 2010 01:17:23 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.2.00.1005062216430.10792@localhost.localdomain> <201005080039.45533.rjw@sisk.pl> <alpine.LFD.2.00.1005071600030.901@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005071600030.901@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005080117.23760.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 May 2010, Linus Torvalds wrote:
> 
> On Sat, 8 May 2010, Rafael J. Wysocki wrote:
> 
> > On Friday 07 May 2010, Linus Torvalds wrote:
> > > 
> > > Btw, why don't we just force the SCI_EN by hand?
> > 
> > Because there are boxes that are broken right away by this.
> > 
> > I have one on my desk in front of me. :-)
> 
> Also if we check whether it was already set before?

Yes.

> The thing is, if that bit is clear (_after_ we've done the regular ACPI 
> setup), the box can't work correctly as far as I know.

That's correct.  But on that particular box acpi_enable() is necessary to
make things work.  Setting SCI_EN by hand makes it hang solid.

Rafael
