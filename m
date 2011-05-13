Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab1EMSoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:44:06 -0400
Received: from mx1.netlogicmicro.com ([12.203.210.36]:2745 "EHLO
	orion5.netlogicmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751496Ab1EMSoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:44:04 -0400
X-TM-IMSS-Message-ID: <50b6596a0004c398@netlogicmicro.com>
Date: Sat, 14 May 2011 00:15:33 +0530
From: "Jayachandran C." <jayachandranc@netlogicmicro.com>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] MIPS: Replace _PAGE_READ with _PAGE_NO_READ
Message-ID: <20110513184532.GC14607@jayachandranc.netlogicmicro.com>
References: <7aa38c32b7748a95e814e5bb0583f967@localhost>
 <20110513150707.GA26389@linux-mips.org>
 <BANLkTikcyEzjOWt9pWToE=89dySSEYbw_g@mail.gmail.com>
 <20110513155605.GA30674@linux-mips.org>
 <BANLkTinnALQV6dXkJ0AjaQ1=bTawYMMkuQ@mail.gmail.com>
 <20110513173633.GA14607@jayachandranc.netlogicmicro.com>
 <BANLkTim+z7TSCvNA2duA6LsUzNsiu9OQaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim+z7TSCvNA2duA6LsUzNsiu9OQaQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 13 May 2011 18:44:31.0519 (UTC) FILETIME=[CBE482F0:01CC119D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 10:51:44AM -0700, Kevin Cernekee wrote:
> On Fri, May 13, 2011 at 10:36 AM, Jayachandran C.
> <jayachandranc@netlogicmicro.com> wrote:
> > For 32-bit the config is nlm_xlr_defconfig in the source tree. Let me know if
> > you need any further info.
> 
> Would you be able to dump out the TLB handlers in this configuration,
> per David's suggestion?

The current linux-mips queue works for me, and I don't have the old source
or binaries with me anymore. You surely should be able build with
nlm_xlr_defconfig and see if the rixi is enabled in the build, if you want
any config register dump on the CPU, please let me know.

JC.
