Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384Ab2DKWwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:52:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37254 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760811Ab2DKWwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:52:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [Regression + patch] i915 / PM: System resume broken on 945GM
Date: Thu, 12 Apr 2012 00:56:48 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <201204120012.46826.rjw@sisk.pl> <20120411222002.GA27568@kroah.com>
In-Reply-To: <20120411222002.GA27568@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204120056.49066.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, April 12, 2012, Greg Kroah-Hartman wrote:
> On Thu, Apr 12, 2012 at 12:12:46AM +0200, Rafael J. Wysocki wrote:
> > Hi Chris,
> > 
> > Unfortunately, your commit
> > 
> > commit 7dd4906586274f3945f2aeaaa5a33b451c3b4bba
> > Author: Chris Wilson <chris@chris-wilson.co.uk>
> > Date:   Wed Mar 21 10:48:18 2012 +0000
> > 
> >     drm/i915: Mark untiled BLT commands as fenced on gen2/3
> > 
> > breaks system resume on my Toshiba Portege R500 (945GM) which hangs hard
> > during or right after returning to X.
> 
> Luckily this patch didn't apply properly to the 3.3-stable tree :)

Your box hanged during resume from suspend with it IIRC, though, or was that
a different issue?

Rafael
