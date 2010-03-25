Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750866Ab0CYEDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 00:03:47 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:32071 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab0CYEDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 00:03:46 -0400
Subject: Re: Regression in i915 on 2.6.34-rc1
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: dri-devel@lists.sourceforge.net, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100321181920.1330d55a@redhat.com>
References: <20100311003358.58194366@redhat.com>
	 <1268535744.28444.16.camel@dc7800.home>
	 <201003151151.01891.bjorn.helgaas@hp.com>
	 <201003170926.59931.bjorn.helgaas@hp.com>
	 <20100321181920.1330d55a@redhat.com>
Content-Type: text/plain
Date: Wed, 24 Mar 2010 22:04:02 -0600
Message-Id: <1269489842.31485.43.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-21 at 18:19 -0600, Pete Zaitcev wrote:
> On Wed, 17 Mar 2010 08:26:59 -0700
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > > > > http://bugzilla.kernel.org/show_bug.cgi?id=15533
> > 
> > Any luck testing the patch from the bugzilla?  I'd really like to get
> > this figured out so we can get the fix in the next -rc and move on
> > to the next _CRS issue :-)
> 
> I was on vacation, sorry. Got to it today. In short, the test patch fails.
> Please see the dmesg with ACPI debugging in bugzilla as requested.

Ping!  If you haven't seen the last bugzilla update, I'd really like an
acpidump and some details about what machine this is.

Thanks,
  Bjorn


