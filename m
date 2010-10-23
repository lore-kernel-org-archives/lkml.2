Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab0JWR6U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 13:58:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46666 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902Ab0JWR6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 13:58:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christian Ruediger Bahls <lkml@qb352.de>
Subject: Re: intel_idle .. Was: __pm_runtime_resume() returns -1 Was: Regression in 2.6.36
Date: Sat, 23 Oct 2010 19:57:28 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
References: <AANLkTinPyg2ijrBydVyoGJiQJCpL7j1_vnyQWnx0eucz@mail.gmail.com> <20101022165734.d7ed2582.akpm@linux-foundation.org> <20101023042607.GB449@pfau.e-technik1.uni-rostock.de>
In-Reply-To: <20101023042607.GB449@pfau.e-technik1.uni-rostock.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010231957.28276.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 23, 2010, Christian Ruediger Bahls wrote:
> [2010-10-23 01:58] Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Fri, 22 Oct 2010 15:38:01 +0200
> > Christian Bahls <lkml@qb352.de> wrote:
> > > The regression seems to have been introduced by the merge:
> > >   92b4522f72916ff2675060e29e4b24cf26ab59ce
> > > 
> >
> > I suspect your bisection went wrong :(
> ...
> > It's really hard to see how that change could break the resume
> > operation.
> 
> you were right ..
> 
> btw: this is not resume but system boot .. either cold or warm
>  [pressing any button(even the power-button) makes the boot continue]
> 
> the failure has lots of different incarnations:
>  during booting it sometimes stalls:
>  on initializing the sata drive
>  while mounting/un-mounting the sata drive
>  or other obscure occasions (syncing drives/initializing hardware)
> 
> in later versions of the kernel it throws the 
>  "__pm_runtime_resume() returns -1"-warnings

Do you have CONFIG_PM_VERBOSE set in your .config by chance?

Rafael
