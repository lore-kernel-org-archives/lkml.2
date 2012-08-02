Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab2HBBn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 21:43:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:7011 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab2HBBnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 21:43:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="174398323"
Date: Wed, 1 Aug 2012 18:43:24 -0700
From: Jon Mason <jon.mason@intel.com>
To: chetan loke <loke.chetan@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>
Subject: Re: [RFC v2 1/2] PCI-Express Non-Transparent Bridge Support
Message-ID: <20120802014324.GB17548@jonmason-lab>
References: <1343607994-32415-1-git-send-email-jon.mason@intel.com>
 <1343607994-32415-2-git-send-email-jon.mason@intel.com>
 <CAErSpo4p_hxvCeVGqiTXVq3itXepheQZerpqRHwLvG6A7R2Lcg@mail.gmail.com>
 <20120730181542.GA987@jonmason-lab>
 <CAErSpo6gjMf4C3RMn5YLNg5JtJ8CjHvTw1iqsKPa6YuRqPe90g@mail.gmail.com>
 <CAAsGZS5kOyQ5FQ7Jg3HxOmmPNYS+F6XcB-_3tm=rcgDV7wAvRQ@mail.gmail.com>
 <20120731172709.GB14080@jonmason-lab>
 <CAAsGZS4nhv+s7NVwaaGjQ9fJoHQoaXnUoYw=xTPC-sfen+tj8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAsGZS4nhv+s7NVwaaGjQ9fJoHQoaXnUoYw=xTPC-sfen+tj8A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 02:02:25PM -0400, chetan loke wrote:
> On Tue, Jul 31, 2012 at 1:27 PM, Jon Mason <jon.mason@intel.com> wrote:
> >
> > I don't see the benefit of having the driver in staging.  Any vendors
> > who would notice the ntb driver in staging would be sitting on these
> > mailing lists and hopefully have planety of comments on the design.
> > Stashing the driver in staging while waiting for these comments (which
> > may never come) doesn't seem the best course of action.
> >
> 
> I thought that since others are talking about it then may be there is
> some WIP code for foo-NTB. Seems like that's not the case. So no need
> to stage.
> 
> Correct me if I'm wrong but wouldn't apps just open a socket and route
> data via ntb_vir_eth_dev? So I don't see an ABI breakage issue and
> hence nothing would prevent us from changing the kernel parts(for
> accommodating some foo-NTB part) in future.

The virtual ethernet device (patch #2) would allow for a generic way
of passing data to the remote side.  The only issue would be changing
how it is encoded in the shared buffer.

> It may not be a bad idea to prefix intel-specific(if any)
> ntb_structs/variables/logic with the 'intc'(Intel ticker or pick your
> string) keyword.

The Intel specific things are current pre-pended with "xeon" or "bwd".

Thanks,
Jon


> 
> Chetan Loke
