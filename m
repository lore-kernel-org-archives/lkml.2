Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab0D1PSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:18:01 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:57896 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab0D1PR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:17:58 -0400
Date: Wed, 28 Apr 2010 17:18:38 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linux-s390@vger.kernel.org,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Apr 27 - S390 boot failure.
Message-ID: <20100428151838.GA2772@osiris.boeblingen.de.ibm.com>
References: <4BD7D399.2090601@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD7D399.2090601@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 11:50:09AM +0530, Sachin Sant wrote:
> Yesterday's -next (20100427) fails to boot on a s390.
> Here is the boot log.
> [...]
> 01: HCPGSP2627I The virtual machine is placed in CP mode due to a SIGP initial C
> PU reset from CPU 00.
> 02: HCPGSP2627I The virtual machine is placed in CP mode due to a SIGP initial C
> PU reset from CPU 00.
> 03: HCPGSP2627I The virtual machine is placed in CP mode due to a SIGP initial C
> PU reset from CPU 00.
> 
> At this point the boot process just hangs. Previous -next build
> (20100415) worked fine.
> Have attached the .config

Yes, I got several reports about this. The patch "improve irq tracing code
in entry[64].S" was broken for !CONFIG_PREEMPT. I fixed it and pushed out
a new version.
Should be fixed with tomorrow's linux-next.

Thanks for reporting!
