Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab2HIJtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:49:41 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:50311 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab2HIJtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:49:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH] mmc: sdio: Fix PM_SLEEP related build warnings
Date: Thu, 9 Aug 2012 11:55:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Chris Ball <cjb@laptop.org>, Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1344495413-7164-1-git-send-email-thierry.reding@avionic-design.de> <201208091127.03119.rjw@sisk.pl> <20120809092756.GA1020@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120809092756.GA1020@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201208091155.34573.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 09, 2012, Thierry Reding wrote:
> On Thu, Aug 09, 2012 at 11:27:02AM +0200, Rafael J. Wysocki wrote:
> > On Thursday, August 09, 2012, Thierry Reding wrote:
> > > Power management callbacks defined by SIMPLE_DEV_PM_OPS are only used if
> > > the PM_SLEEP Kconfig symbol has been defined. If not, the compiler will
> > > complain about them being unused.
> > > 
> > > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > 
> > The pm_no_operation() thing is not necessary at all, AFAICT.  I'd just
> > remove it entirely. :-)
> 
> I don't actually have a setup where I can test suspend/resume with this
> driver, but if you say so I can follow up with a patch that removes
> pm_no_operation(). It should work because many drivers without proper
> PM_SLEEP support do not specify .suspend() nor .resume() callbacks
> either.

Sure, it should work.

Thanks,
Rafael
