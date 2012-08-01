Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab2HAUas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:30:48 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:39688 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab2HAUar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:30:47 -0400
Date: Wed, 1 Aug 2012 22:28:40 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Roland Dreier <roland@kernel.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: mellanox mlx4_core and SR-IOV
Message-ID: <20120801202840.GM5470@ics.muni.cz>
References: <20120801133835.GH5470@ics.muni.cz>
 <CAG4TOxONLJnBaY7N5x7Kfi+dwCb507QPqX9s_Wuef10+RzM=AQ@mail.gmail.com>
 <CAE9FiQUSFeBpGaFByOfENUa8qg7t89WTiUann8=4ezT7s2qmzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQUSFeBpGaFByOfENUa8qg7t89WTiUann8=4ezT7s2qmzw@mail.gmail.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Muni-Spam-TestIP: 94.112.253.31
X-Muni-Envelope-From: xhejtman@ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 01 Aug 2012 22:28:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 11:29:02AM -0700, Yinghai Lu wrote:
> On Wed, Aug 1, 2012 at 10:37 AM, Roland Dreier <roland@kernel.org> wrote:
> > On Wed, Aug 1, 2012 at 6:38 AM, Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:
> >> [    3.558296] mlx4_core 0000:02:00.0: not enough MMIO resources for SR-IOV (nres: 0, iov->nres: 1)
> >
> > This comes from the core sriov_enable() function, not anything in mlx4.
> > (although my kernel doesn't have the print of nres in that message)
> >
> > Not sure what it means.
> 
> iov bar is not assigned by BIOS, and kernel can not find range for it too.
> 
> Lukas, can you post whole boot log with PCI_DEBUG enabled? That will
> tell exact why kernel does not assign them.
> 
> Recent kernel from 3.4... should enable realloc when SRIOV bar is not assigned.

here is full boot log.
http://www.fi.muni.cz/~xhejtman/dmesg.log

weird with PCI_DEBUG it does not load mlx driver at all..

-- 
Luká¹ Hejtmánek
