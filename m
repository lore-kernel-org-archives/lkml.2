Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab0EXSsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:48:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35021 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab0EXSsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:48:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: felipe.balbi@nokia.com
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
Date: Mon, 24 May 2010 20:49:18 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
       Kevin Hilman <khilman@deeprootsystems.com>
References: <1274482015-30899-1-git-send-email-arve@android.com> <201005240246.55043.rjw@sisk.pl> <20100524043224.GA31700@nokia.com>
In-Reply-To: <20100524043224.GA31700@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005242049.18920.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 May 2010, Felipe Balbi wrote:
> On Mon, May 24, 2010 at 02:46:54AM +0200, ext Rafael J. Wysocki wrote:
> >On Saturday 22 May 2010, Arve Hjønnevåg wrote:
> >> This patch series adds a suspend-block api that provides the same
> >> functionality as the android wakelock api. This version adds a
> >> delay before suspending again if no suspend blockers were used
> >> during the last suspend attempt.
> >
> >Patches [1-6/8] applied to suspend-2.6/linux-next
> 
> funny thing is that even without sorting out the concerns plenty of 
> developers had on the other thread, this series is still taken. What's 
> the point in dicussing/reviewing the patches then ?

I don't think the concerns you're referring to can be solved out.  Some people
just don't like the whole idea and I don't think there's any way we can improve
the patches to make them happy.  The only "solution" they would be satisfied
with would simply be rejecting the feature altogether, although there are no
practically viable alternatives known to me.

OTOH I do think there are quite a few reasons to take the patchset, so I'm
going to push it to Linus as I told in one of my replies to Kevin.  If Linus
decides not to pull it, so be it.

Thanks,
Rafael
