Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0EGWit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 18:38:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57136 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab0EGWir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 18:38:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull request] ACPI patches for 2.6.34-rc6
Date: Sat, 8 May 2010 00:39:45 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.2.00.1005062216430.10792@localhost.localdomain> <alpine.LFD.2.00.1005061926460.901@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005061926460.901@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005080039.45533.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 May 2010, Linus Torvalds wrote:
> 
> On Thu, 6 May 2010, Len Brown wrote:
> > 
> > The big DMI list in sleep.c a temporary brute force and low-risk workaround.
> > We will endeavor to delete it entirely in 2.6.35 with a clean fix
> > that was deemed too risky for this late in the .34 release cycle.
> 
> Btw, why don't we just force the SCI_EN by hand?

Because there are boxes that are broken right away by this.

I have one on my desk in front of me. :-)

Rafael
