Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab0FGOLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 10:11:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40326 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab0FGOLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 10:11:08 -0400
Date: Mon, 7 Jun 2010 15:11:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: ThinkPad T400 : should kernel option "reboot=pci" be hard
	coded ?
Message-ID: <20100607141103.GA9477@srcf.ucam.org>
References: <201006071122.21925.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201006071122.21925.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 11:22:21AM +0200, Toralf Förster wrote:
> Since some kernel version (IIRC since 2.6.31) it is necessary to boot the 
> linux kernel with that option to prevent an extra 9 seconds delay during 
> reboot.
> I found this tip on the LKML -and now I'm wondering whether this option should 
> be hard coded in the kernel sources b/c it seems to be necessary for current 
> kernels too.

No, the best thing to do would be to figure out what changed to require 
the extra 9 seconds. Are you able to work out which the last kernel 
release without this timeout was?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
