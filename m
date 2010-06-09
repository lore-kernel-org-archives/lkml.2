Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab0FIN0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 09:26:31 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:34411 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753538Ab0FIN03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 09:26:29 -0400
Date: Wed, 9 Jun 2010 09:26:21 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: ThinkPad T400 : should kernel option "reboot=pci" be hard
 coded ?
Message-ID: <20100609132621.GA25403@elliptictech.com>
Mail-Followup-To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <201006071122.21925.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201006071122.21925.toralf.foerster@gmx.de>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:22 Mon 07 Jun     , Toralf Förster wrote:
> Since some kernel version (IIRC since 2.6.31) it is necessary to boot the 
> linux kernel with that option to prevent an extra 9 seconds delay during 
> reboot.
> I found this tip on the LKML -and now I'm wondering whether this option should 
> be hard coded in the kernel sources b/c it seems to be necessary for current 
> kernels too.

Wow!  That delay has been frustrating me since I bought my T500 last
year.  I had tried a couple reboot= options (triple, acpi) and they all
had the delay, so I figured it was something inherent with the system
firmware.

But reboot=pci works perfectly!  Thanks for the tip.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
