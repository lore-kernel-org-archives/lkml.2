Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab2AQBA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 20:00:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372Ab2AQBAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 20:00:23 -0500
Date: Mon, 16 Jan 2012 17:00:06 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Djalal Harouni <tixxdz@opendz.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Sergei Trofimovich <slyich@gmail.com>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        Ming Lei <tom.leiming@gmail.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>, justinmattock@gmail.com,
        Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH] mce: fix warning messages about static struct mce_device
Message-ID: <20120117010006.GB14863@suse.de>
References: <20120116224028.GA5072@suse.de>
 <20120117001403.GC18875@dztty>
 <20120117001548.GA6884@suse.de>
 <CA+55aFzCsRM-w3JY13VUxmbZYGKAs0qrFS28QjHsTW9+5BuZJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzCsRM-w3JY13VUxmbZYGKAs0qrFS28QjHsTW9+5BuZJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 04:21:20PM -0800, Linus Torvalds wrote:
> On Mon, Jan 16, 2012 at 4:15 PM, Greg KH <gregkh@suse.de> wrote:
> >
> > Linus, do you want to take this directly from the email, or do you want
> > me to put it in a tree to pull from?
> 
> Do you have anything else pending before I close the merge window? If
> so, put it in a tree with those.
> 
> If not, let me know, and I'll just take the patch as-is.

Nope, nothing else from me for the big 3.3-rc1 merge, so please take it
as-is.

thanks,

greg k-h
