Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab0EHACj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 20:02:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57304 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310Ab0EHACh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 20:02:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull request] ACPI patches for 2.6.34-rc6
Date: Sat, 8 May 2010 02:03:30 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.2.00.1005062216430.10792@localhost.localdomain> <201005080117.23760.rjw@sisk.pl> <alpine.LFD.2.00.1005071618410.901@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005071618410.901@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005080203.30634.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 May 2010, Linus Torvalds wrote:
> 
> On Sat, 8 May 2010, Rafael J. Wysocki wrote:
...
> 
> Let me explain what I think we should do with actual code:
> 
> 	acpi_enable();
> 	if (test_if_that_f_cking_bit_still_isnt_set)
> 		set_it_by_hand();
> 
> wouldn't that work on your box?

Yes, it would.

> The acpi_enable() seems to work for you, so it wouldn't actually ever set it
> by hand. 
>
> But the problem is that on a number of boxes, acpi_enable() apparently 
> doesn't do what it should do. Because the stupid BIOS "knows" it is 
> already in ACPI mode, but it forgot to actually set the bit!

To calrify, I think the approach in the Matthew's patch is correct, but since I have
some bad experience with that particular thing, I prefer to make that change in
2.6.35 and then move on to drop the flag entirely.

Rafael
