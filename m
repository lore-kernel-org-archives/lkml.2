Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab1F2BFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 21:05:16 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34265 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab1F2BFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 21:05:08 -0400
Date: Tue, 28 Jun 2011 18:04:48 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org
Subject: Re: [git pull] PCI fixes
Message-ID: <20110629010448.GA20319@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20110623133740.0cdaf204@jbarnes-desktop>
 <BANLkTime_w_RLqU2dZV4zx9SEZaNTQoMNQ@mail.gmail.com>
 <20110624085318.70bde05c@jbarnes-desktop>
 <BANLkTinimDSWQaDcQj9nJj11juK2OCfLXg@mail.gmail.com>
 <20110624091148.18f8959d@jbarnes-desktop>
 <204d042e-86c0-41a5-80f0-e04d6b7adf25@email.android.com>
 <20110628100227.28f471aa@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110628100227.28f471aa@jbarnes-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 10:02:27AM -0700, Jesse Barnes wrote:
> On Fri, 24 Jun 2011 15:56:42 -0700
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > 
> > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > >
> > >How about a boot param?  We've done similar things for _CRS, and it
> > >might give Yinghai and Ram some more flexibility in improving our
> > >dynamic resource allocation before enabling it again (if ever).
> > 
> > I'm OK with that, but then I'd suggest against the currently not yet merged series that doesn't seem to work anyway...
> > 
> > IOW, just a simple patch that disables the resource re-allocation, and enables it with some command line option.
> 
> Ram or Yinghai, want to come up with something?  (And
> note: pci=bridge_realloc or something would be a lot more descriptive
> than pci=try=2!)
Jesse,

	Will have something your way soon.

RP
