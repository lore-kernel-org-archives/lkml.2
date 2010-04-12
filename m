Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab0DLMx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 08:53:28 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:57143 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878Ab0DLMx1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 08:53:27 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Apr 2010 08:53:26 EDT
X-AuditID: 12074425-b7d00ae000002295-70-4bc31698986f
Subject: Re: LOCALVERSION_AUTO considered harmful
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <33355.71.245.98.113.1271040992.squirrel@www.xenotime.net>
Date: Mon, 12 Apr 2010 08:48:14 -0400
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Pavel Machek" <pavel@ucw.cz>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@osdl.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <BEB2242A-4073-46B8-B178-16104B49D888@mit.edu>
References: <20100411164701.GA7558@elf.ucw.cz> <20100412185136.GA13171@x200> <g2v10f740e81004111158r4d4714a1w23b8521d5d595b29@mail.gmail.com> <20100411201426.GC25294@elf.ucw.cz> <alpine.LFD.2.00.1004120022230.18009@localhost.localdomain> <33355.71.245.98.113.1271040992.squirrel@www.xenotime.net>
To: rdunlap@xenotime.net
X-Mailer: Apple Mail (2.1078)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 11, 2010, at 10:56 PM, rdunlap@xenotime.net wrote:
> 
> So what do you suggest?  If the "magic" strings contain "-dirty ",
> then ignore that and the 2 preceding hyphen-separated fields?

I have a standard local patch that I've been carrying for I-don't-know-how-long which just nukes the "-dirty" suffix, which I needed because make-kpkg modifies some kernel build files, so the version string would always have 
-dirty.

It's not hard to fix...

-- Ted

