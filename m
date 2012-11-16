Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2KPTYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:24:30 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45809 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab2KPTY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:24:28 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alexandra Chin <alexandra.chin@tw.synaptics.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: Re: [RFC] staging: ste_rmi4: merge into the main kernel tree
Date: Fri, 16 Nov 2012 11:24:21 -0800
Message-ID: <4047245.snaaN8zA9U@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.9.2 (Linux/3.7.0-rc4+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <CC51EC7B5B7F984AA566DC102237848896F62D19@hkdcw-mail1.synaptics-inc.local>
References: <20121103013623.0f3a1b28168a9a42881b0b00@tw.synaptics.com> <20121115064359.GA17551@core.coreip.homeip.net> <CC51EC7B5B7F984AA566DC102237848896F62D19@hkdcw-mail1.synaptics-inc.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 16, 2012 09:02:30 AM Alexandra Chin wrote:
> Hi Dmitry,
> 
> > > > Please have Greg commit the patch that Henrik reviewed to staging and
> > > > then work with Christopher Heiny group on getting the full featured
> > > > driver into mainline.
> 
> Thanks for your reminding, final patch has been re-sent to staging
> maintainer.
> 
> > In this case you need to enumerate the benefits of this driver over
> > unified driver and show why the unified driver can't be fixed.
> > 
> > Currently the driver is in mainline (even though the directory is
> > staging) and nobody will remove it until another driver is fully
> > functional and ready for prime time. But once this happens I do not see
> > the benefits of maintaining 2 drivers for the same hardware.
> 
> I see. Given that the driver will remain in mainline before generic driver
> is ready, currently I will continue to maintain the driver in staging.

Sounds like a plan.

Thanks!

-- 
Dmitry
