Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1KVOpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:45:19 -0500
Received: from gherkin.frus.com ([192.158.254.49]:38646 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755641Ab1KVOpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:45:17 -0500
X-Greylist: delayed 1434 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Nov 2011 09:45:17 EST
Date: Tue, 22 Nov 2011 08:21:21 -0600
From: Bob Tracy <rct@gherkin.frus.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.2-rc2 regression: floppy driver breaks boot
Message-ID: <20111122142121.GB2013@gherkin.frus.com>
References: <20111122111405.GA28215@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122111405.GA28215@elf.ucw.cz>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 12:14:06PM +0100, Pavel Machek wrote:
> 3.2-rc1..rc2 fail to boot, due to some warn-on in block layer. It
> seems that floppy driver is responsible.
> 
> I'll try to turn the floppy driver off and see what happens.
> 
> Seems like floppy driver has no maintianer :-(.

Might be my issue as well.  I've got an old AMD K6-III/450 system with
two floppy drives.  When booting 3.2-rc2 (didn't try "-rc1"), the system
switches video modes (VESA FB console), and then hangs/panics.  No
further info available because the panic happens too early for syslog to
record it, and the console goes blank at the time of the mode switch:
there's nothing on the screen I might transcribe manually.  3.1-final
works fine.

--Bob
