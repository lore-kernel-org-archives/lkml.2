Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab2CBVwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:52:31 -0500
Received: from gate.crashing.org ([63.228.1.57]:35025 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab2CBVwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:52:30 -0500
Message-ID: <1330725132.11728.52.camel@pasglop>
Subject: Re: linux-next: boot failure for next-20120227 and later (pci tree
 related)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, ppc-dev <linuxppc-dev@lists.ozlabs.org>
Date: Sat, 03 Mar 2012 08:52:12 +1100
In-Reply-To: <CAErSpo6xQa4Rnv+RkkXCRjQ2HDZdBhorRv2c6pmWyXqRzhM4Vw@mail.gmail.com>
References: <20120302170638.3d172369d04335d9b921a28c@canb.auug.org.au>
	 <CAErSpo6xQa4Rnv+RkkXCRjQ2HDZdBhorRv2c6pmWyXqRzhM4Vw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 10:10 -0700, Bjorn Helgaas wrote:
> On Thu, Mar 1, 2012 at 11:06 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Jesse,
> >
> > Staring with next-20120227, one of my boot tests is failing like this:
> 
> Hi Stephen,
> 
> Thanks a lot for the test report and the bisection.  I wish I had a
> machine to test on so I wouldn't have to bother you about it.
> 
> Any chance you could point me at the complete before/after dmesg logs?
>  There should be information about the PCI host bridge apertures and
> offsets in the "after" log.  If that's not enough, we might need to
> collect new before/after logs with something like this
> (whitespace-mangled):

Or give me a chance to dig :-) I'll have a look next week.

Cheers,
Ben.


