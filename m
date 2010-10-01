Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab0JAMKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:10:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:49643 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182Ab0JAMKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 08:10:11 -0400
Subject: Re: [PATCH 01/18] powerpc: Add ability to build little endian
 kernels
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Albert Herranz <albert_herranz@yahoo.es>, linux-kernel@vger.kernel.org,
        paulus@samba.org, Ian Munsie <imunsie@au1.ibm.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org,
        Torez Smith <lnxtorez@linux.vnet.ibm.com>
In-Reply-To: <AANLkTimGtB_KoOgwk3Ujn2UcNzs9qHxzeZcb1ShLgcXh@mail.gmail.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	 <1285916771-18033-2-git-send-email-imunsie@au1.ibm.com>
	 <F7E7DAE6-A132-458D-ABC3-4CC92A4C7263@kernel.crashing.org>
	 <AANLkTimGtB_KoOgwk3Ujn2UcNzs9qHxzeZcb1ShLgcXh@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 22:09:13 +1000
Message-ID: <1285934953.2463.72.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 07:28 -0400, Josh Boyer wrote:
> > Shouldn't we have something that limits to the sub-arch'es that
> actually support it?  I doubt I'm ever going to make FSL-Book-e
> support LE.
> 
> Yes, it should. 

Sure, that's only WIP patches :-)

Tho FSL BookE would be relatively easy...

Cheers,
Ben.


