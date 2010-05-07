Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0EGXDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 19:03:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753398Ab0EGXDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 19:03:13 -0400
Date: Fri, 7 May 2010 16:00:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull request] ACPI patches for 2.6.34-rc6
In-Reply-To: <201005080039.45533.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1005071600030.901@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1005062216430.10792@localhost.localdomain> <alpine.LFD.2.00.1005061926460.901@i5.linux-foundation.org> <201005080039.45533.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 8 May 2010, Rafael J. Wysocki wrote:

> On Friday 07 May 2010, Linus Torvalds wrote:
> > 
> > Btw, why don't we just force the SCI_EN by hand?
> 
> Because there are boxes that are broken right away by this.
> 
> I have one on my desk in front of me. :-)

Also if we check whether it was already set before?

The thing is, if that bit is clear (_after_ we've done the regular ACPI 
setup), the box can't work correctly as far as I know.

			Linus
