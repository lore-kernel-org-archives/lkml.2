Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0DAJUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 05:20:54 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:51795 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab0DAJUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 05:20:47 -0400
Date: Thu, 1 Apr 2010 12:18:08 +0300
From: Ozgur Yuksel <ozgur.yuksel@oracle.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bugme-new] [Bug 15621] New: BUG: unable to handle kernel
 paging request - comm: pccardd
Message-ID: <20100401091808.GA3236@oracle.com>
References: <bug-15621-10286@https.bugzilla.kernel.org/>
 <20100325170138.GA5424@comet.dominikbrodowski.net>
 <20100329091241.GA3237@oracle.com>
 <201003301711.00351.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003301711.00351.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BB464EE.0047:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tue, Mar 30, 2010 at 05:10:59PM -0600 was the time for Bjorn Helgaas to speak thus:
> Anyway, I'd like to see the entire dmesg log when booted *without*
> pci=nocrs, because that's the case that fails.  Since the system doesn't
> boot, you'll have to use a serial console or netconsole to collect the
> whole thing.  The serial console log in comment 7 is corrupted; it looks
> like all the lines got truncated to 80 columns or something.  And please
> boot with "ignore_loglevel" so we see all the debug messages on the console.

Interestingly when ignore_loglevel is used, the problem does not reproduce. Now
I'll proceed with actions in comment #11.
