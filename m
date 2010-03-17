Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab0CQP1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:27:06 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:20286 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab0CQP1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:27:03 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: Regression in i915 on 2.6.34-rc1
Date: Wed, 17 Mar 2010 08:26:59 -0700
User-Agent: KMail/1.9.10
Cc: dri-devel@lists.sourceforge.net, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
References: <20100311003358.58194366@redhat.com> <1268535744.28444.16.camel@dc7800.home> <201003151151.01891.bjorn.helgaas@hp.com>
In-Reply-To: <201003151151.01891.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003170926.59931.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 March 2010 11:51:01 am Bjorn Helgaas wrote:
> On Saturday 13 March 2010 08:02:24 pm Bjorn Helgaas wrote:
> > On Sat, 2010-03-13 at 13:46 -0700, Pete Zaitcev wrote:
> > > On Fri, 12 Mar 2010 22:37:56 -0700
> > > Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > 
> > > > Thanks for the report.  Would you mind posting the entire dmesg
> > > > log, /proc/iomem contents, and "lspci -vv" output somewhere (maybe in
> > > > bugzilla)?
> > > 
> > > Done, new bug:
> > > http://bugzilla.kernel.org/show_bug.cgi?id=15533

Any luck testing the patch from the bugzilla?  I'd really like to get
this figured out so we can get the fix in the next -rc and move on
to the next _CRS issue :-)

Bjorn
