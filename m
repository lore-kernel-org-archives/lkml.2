Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab2BAOm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:42:28 -0500
Received: from mail.tomasu.net ([64.85.170.232]:33599 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab2BAOm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:42:26 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: John Robinson <john.robinson@anonymous.org.uk>,
        "linux-raid" <linux-raid@vger.kernel.org>
Subject: Re: GRUB doesn't like ServeRAID M1015/LSI 9220-8i (was Re: mvsas with 3.1)
Date: Wed, 1 Feb 2012 07:42:07 -0700
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <201201131144.58044.thomas@fjellstrom.ca> <201202010703.09833.thomas@fjellstrom.ca> <4F294E64.10204@anonymous.org.uk>
In-Reply-To: <4F294E64.10204@anonymous.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202010742.07818.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Feb 1, 2012, John Robinson wrote:
> On 01/02/2012 14:03, Thomas Fjellstrom wrote:
> [...]
> 
> >  I picked up a refurb IBM
> > 
> > ServeRaid M1015 (aka: LSI 9220-8i) card. It arrived yesterday. Just have
> > to wait and see why grub doesn't like it.
> 
> When you find out, please let me know - I bought one via ebay, its
> firmware was elderly and wouldn't let me put it in JBOD mode, after a
> bit of googling I flashed it with IBM's latest firmware, then GRUB
> thought my machine had no RAM in it. The card has been sitting in a box
> since.

Yeah, GRUB immediately throws an "out of memory. Aborted" error, its annoying, 
but I reported the issue on GRUB's bug tracker after talking to a guy in #grub 
on freenode. Hopefully someone looks at it soon. It appears it happens so 
early in grub's startup that it can't even output any debug info (I was asked 
to run: `grub-install --debug-image=all /dev/sdX`, and did so, I get debug 
output when the card is not installed, but absolutely nothing when it is 
installed.

> Cheers,
> 
> John.


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
