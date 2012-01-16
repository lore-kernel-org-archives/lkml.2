Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab2APAlV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 19:41:21 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51915 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab2APAlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 19:41:19 -0500
Date: Mon, 16 Jan 2012 00:41:10 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] x86 / reboot: Blacklist Dell OptiPlex 990 known to
 require PCI reboot
Message-ID: <20120116004110.GA21240@srcf.ucam.org>
References: <201111160019.51303.rjw@sisk.pl>
 <201201091700.09318.roucaries.bastien@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201201091700.09318.roucaries.bastien@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 05:00:08PM +0100, bastien ROUCARIES wrote:
> Le Wednesday 16 November 2011 00:19:51, Rafael J. Wysocki a écrit :
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Dell OptiPlex 990 is known to require PCI reboot, so add it to the reboot
> > blacklist in pci_reboot_dmi_table[].
> 
> 
> Sorry to hi jack this thread but it seems that dell made the same crap with my precision T1600. See 
> http://www.centos.org/modules/newbb/print.php?form=1&topic_id=32948&forum=55&order=ASC&start=0
> or
> https://bugzilla.redhat.com/show_bug.cgi?id=698239

Does it work if you disable VT-d in the firmware? If so, then adding it 
to the reboot method blacklist is the wrong fix - we need to figure out 
why VT-d interferes with Dell's reboot code.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
