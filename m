Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0HRQSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:18:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:33131 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab0HRQSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:18:23 -0400
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
From: James Bottomley <James.Bottomley@suse.de>
To: Chetan Loke <chetanloke@gmail.com>
Cc: Chetan Loke <generationgnu@yahoo.com>,
        Vladislav Bolkhovitin <vst@vlnb.net>,
        scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	 <1282144271.3035.31.camel@mulgrave.site>
	 <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 11:18:16 -0500
Message-ID: <1282148296.3035.49.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 12:04 -0400, Chetan Loke wrote:
> On Wed, Aug 18, 2010 at 11:11 AM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> > The decision hasn't been taken to merge LIO, but based on what happened
> > at the summit, I think it's the most viable candidate and will likely be
> > merged by 2.6.37
> >
> 
> During the open panel, facebook guys and others were tooting that
> start-ups thrive because they can hack linux. Well there are quite a
> few start-ups that use scst too for creating target appliances.
> Has anyone even bothered to glance the scst mailing list to see if
> that community is dead or alive?
> 
> I for one use scst to create synthetic work-loads and test 200+ VM
> nodes in an ESX cluster. Anyone who has worked on a SAN OS will
> appreciate the simplicity of SCST. And if folks still can't understand
> the SCST code(after reading the README) then they are still welcome to
> send an email on SCST. Would you like to make your FC stack go faster,
> well please drop us an email on SCST and we will try our best to
> further optimize the FC driver.
> 
> I know folks who don't understand simple DMA bus traces, FC wire
> traces and yet they have the power to influence decisions.
> 
> James you are an expert but not everyone is. This is not a venting
> session but even folks who are new to target architecture find it easy
> to hack SCST.

But that's not really relevant, is it?  I would expect that whatever I
do, even keeping both out of tree, the communities around the solutions
would still exist and be vibrant, since they're out of tree now, nothing
will have changed.

James


