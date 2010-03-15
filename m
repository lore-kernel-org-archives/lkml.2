Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965134Ab0CORvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 13:51:08 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:11271 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab0CORvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 13:51:05 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: Regression in i915 on 2.6.34-rc1
Date: Mon, 15 Mar 2010 10:51:01 -0700
User-Agent: KMail/1.9.10
Cc: dri-devel@lists.sourceforge.net, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
References: <20100311003358.58194366@redhat.com> <20100313134642.797c35d6@redhat.com> <1268535744.28444.16.camel@dc7800.home>
In-Reply-To: <1268535744.28444.16.camel@dc7800.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003151151.01891.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 March 2010 08:02:24 pm Bjorn Helgaas wrote:
> On Sat, 2010-03-13 at 13:46 -0700, Pete Zaitcev wrote:
> > On Fri, 12 Mar 2010 22:37:56 -0700
> > Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > 
> > > Thanks for the report.  Would you mind posting the entire dmesg
> > > log, /proc/iomem contents, and "lspci -vv" output somewhere (maybe in
> > > bugzilla)?
> > 
> > Done, new bug:
> > http://bugzilla.kernel.org/show_bug.cgi?id=15533
> 
> Thanks!  Sorry, I should have asked for the "pci=nocrs" (working) dmesg,
> too.  Do you have that handy?  What kind of machine is this?  I don't
> suppose you have Windows on it; I'd really like to know what the Device
> Manager says about the PCI host bridge and graphics controller
> resources.

I added two patches to the bugzilla:

  http://bugzilla.kernel.org/attachment.cgi?id=25522 (possible fix)
  http://bugzilla.kernel.org/attachment.cgi?id=25523 (additional debug)

If the first patch fixes it, we're all set.  If it doesn't, I'd like
the additional debug info from the second patch.

Thanks!
  Bjorn
