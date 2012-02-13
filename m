Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2BMCSd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 21:18:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab2BMCSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 21:18:32 -0500
Date: Sun, 12 Feb 2012 21:18:13 -0500
From: Dave Jones <davej@redhat.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Naveen Goswamy <naveen.goswamy@polymtl.ca>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: Kernel crashing on eject SD card
Message-ID: <20120213021813.GA589@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Naveen Goswamy <naveen.goswamy@polymtl.ca>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <1328660390.4f31bfa6e8f4b@www.imp.polymtl.ca>
 <20120212220836.6aa7fa4d@stein>
 <20120212222027.71651e8b@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120212222027.71651e8b@stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 12, 2012 at 10:20:27PM +0100, Stefan Richter wrote:
 > On Feb 12 Stefan Richter wrote:
 > > Modules linked in: [...] vboxnetadp(O) vboxnetflt(O) vboxdrv(O) [...]
 > 
 > Oh, could you try without virtualbox?
 > 
 > The debian bug report hints that kernel 3.2 /without virtualbox drivers/
 > seems to behave itself.
 > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=649735

We've seen this a bunch of times in Fedora too.

Here's a report we've been duping similar bugs against
https://bugzilla.redhat.com/show_bug.cgi?id=754518

Some of them are using vbox/vmware, but there's a few in there that
haven't used either, so I think that might be a red herring.

	Dave


