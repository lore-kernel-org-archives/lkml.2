Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab0LCArX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 19:47:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50223 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079Ab0LCArW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 19:47:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] PM / Hibernate: Fix memory corruption related to swap
Date: Fri, 3 Dec 2010 01:46:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Ondrej Zary <linux@rainbow-software.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <201012030040.37273.rjw@sisk.pl> <20101202155453.92e8ca57.akpm@linux-foundation.org> <alpine.LSU.2.00.1012021622370.26812@tigran.mtv.corp.google.com>
In-Reply-To: <alpine.LSU.2.00.1012021622370.26812@tigran.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012030146.37887.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 03, 2010, Hugh Dickins wrote:
> On Thu, 2 Dec 2010, Andrew Morton wrote:
> > On Fri, 3 Dec 2010 00:40:36 +0100
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > 
> > > This patch is a fix for a regression and nasty memory corruption, so I'd like
> > > to push it to Linus for 2.6.37 if there are no objections.
> 
> (It will need backport to 2.6.35-stable and 2.6.36-stable:
> IIRC it doesn't quite apply cleanly to those, so we'll need
> to send a separate version.)

That's correct.  I'll backport it when it hits the Linus' tree.

Rafael
