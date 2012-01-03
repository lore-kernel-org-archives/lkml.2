Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab2ACVDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 16:03:46 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:51929 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755Ab2ACVDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 16:03:43 -0500
X-Sasl-enc: hMlzio7tHvkGVU7yEacaEsGXHvKlDnRMIHUpJrpsTyHb 1325624623
Date: Tue, 3 Jan 2012 12:52:26 -0800
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-12-15
Message-ID: <20120103205226.GA17131@kroah.com>
References: <20111215191523.GA2561@tuxdriver.com>
 <CACna6rw736JdkoM8zKxorCFd5oy08QTwWZ6PutoJPSr3ZN8hTg@mail.gmail.com>
 <20111215213822.GB2561@tuxdriver.com>
 <CACna6rz3qDpw4eJOoCXx7=z1719v7kS-Ou-WUseR9_vB-O2dag@mail.gmail.com>
 <CACna6rxO2dC=Y3nv-d-w89MqyM0j0aumk=r5Yh_KEg=MwOcvEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACna6rxO2dC=Y3nv-d-w89MqyM0j0aumk=r5Yh_KEg=MwOcvEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 26, 2011 at 12:36:59AM +0100, Rafał Miłecki wrote:
> W dniu 16 grudnia 2011 07:40 użytkownik Rafał Miłecki
> <zajec5@gmail.com> napisał:
> > W dniu 15 grudnia 2011 22:38 użytkownik John W. Linville
> > <linville@tuxdriver.com> napisał:
> >> On Thu, Dec 15, 2011 at 09:04:29PM +0100, Rafał Miłecki wrote:
> >>> 2011/12/15 John W. Linville <linville@tuxdriver.com>:
> >>> > commit 42a3b63bb2ca4996a3d1210a004eae2333f1119e
> >>> >
> >>> > Dave,
> >>> >
> >>> > Here are a few more fixes intended for the 3.2 release.  They are
> >>> > all small and narrowly focused.
> >>>
> >>> John, I've made a mistake and didn't use [PATCH 3.2] header to make it
> >>> clean my patch is fix. Could you take a look at
> >>> [PATCH] bcma: support for suspend and resume
> >>> please?
> >>>
> >>> It's not one-liner, but fixes lock ups, which I believe - we really
> >>> want to avoid.
> >>
> >> It's late in the release cycle, and Dave specifically asked me to slow down.
> >>
> >> Are these suspend/resume lockups a regression?  Or have they always
> >> been there?  Do they happen to everyone?
> >
> > The bug is present since first days of bcma. That's why I even decided
> > to add stable to CC.
> >
> > Personally I've tested that only on 1 machine (I don't have more
> > suspendable machines with mini PCIe slot). However all Macbook 8.1/8.2
> > users have to remove b43 & bcma before suspending [0], they complain
> > about that since ever.
> >
> > Arend: I know you're also complaining for suspend in bcma. Can you
> > comment on this?
> >
> > [0] http://ubuntuforums.org/showthread.php?t=1695746
> 
> User nephyrin on #bcm-users has confirmed this patch fixes
> suspend&resume for him. Without this patch he got deadlock without
> seeing any kernel panic logs - quite an ugly case.
> 
> I still think this patch may be worth taking as fix and backporting too.

What patch specifically?  What is the git commit id of it in Linus's
tree?  Without that information, telling stable@ about it is
pointless...

greg k-h
