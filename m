Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab2JORlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:41:15 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:47468 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab2JORlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:41:14 -0400
MIME-Version: 1.0
X-Originating-IP: [91.205.155.63]
In-Reply-To: <1350280341.2152.12.camel@jtkirshe-mobl>
References: <1350235151-11146-1-git-send-email-dmitry@daynix.com>
	<1350235151-11146-2-git-send-email-dmitry@daynix.com>
	<1350280341.2152.12.camel@jtkirshe-mobl>
Date: Mon, 15 Oct 2012 19:41:13 +0200
Message-ID: <CAGHCxhcsbQsKu4SyUNRf28N1Bt7pW0_LVsj3Hjvs+915cVZQVQ@mail.gmail.com>
Subject: Re: [E1000-devel] [PATCH] RX initialization sequence fixed - enable
 RX after corresponding ring initialization only
From: Dmitry Fleytman <dmitry@daynix.com>
To: jeffrey.t.kirsher@intel.com
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        Chris Webb <chris.webb@elastichosts.com>,
        Richard Davies <richard.davies@elastichosts.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Jeff

According to what we see this problem is very old and exists in stable
branches at least back to 2.6.x.

Since we see this problem a lot on our servers and we cannot recompile
some kernels we use, we are
highly interested in backporting of this patch to older versions to
make it merged into stable distributions.

Is there any chance you could commit it in stable series?
Can we help you with this (i.e. prepare backported patches, etc.)?

Please, advise.

Thanks in advance,
Dmitry Fleytman

On Mon, Oct 15, 2012 at 7:52 AM, Jeff Kirsher
<jeffrey.t.kirsher@intel.com> wrote:
>
> On Sun, 2012-10-14 at 19:19 +0200, Dmitry Fleytman wrote:
> > Reported-by: Chris Webb <chris.webb@elastichosts.com>
> > Reported-by: Richard Davies <richard.davies@elastichosts.com>
> >
> > Signed-off-by: Dmitry Fleytman <dmitry@daynix.com>
> > ---
> >  drivers/net/ethernet/intel/e1000/e1000_ethtool.c |    9 +++++----
> >  drivers/net/ethernet/intel/e1000/e1000_main.c    |   18
> > ++++++++++++++++--
> >  2 files changed, 21 insertions(+), 6 deletions(-)
>
> I will add it to my queue.  Thanks!




--
Dmitry Fleytman
Technology Expert and Consultant,

Daynix Computing Ltd.

Cell: +972-54-2819481

Skype: dmitry.fleytman
