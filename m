Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab2LUSEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 13:04:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60096 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2LUSDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 13:03:54 -0500
Message-ID: <1356113031.32581.4.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.6.11-rt24 (apocalypse release)c
From: Mike Galbraith <bitbucket@online.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Fri, 21 Dec 2012 19:03:51 +0100
In-Reply-To: <1356112760.32581.2.camel@marge.simpson.net>
References: <alpine.LFD.2.02.1212211413200.3148@ionos>
	 <1356106865.4547.60.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1212211729240.3148@ionos>
	 <1356107797.4547.61.camel@marge.simpson.net>
	 <1356108846.4547.66.camel@marge.simpson.net>
	 <1356112760.32581.2.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:efSVZlz09oFLO5nMaad2a7OumDrEE5ac3bKveEzQ9xh
 PVi8pxaq3h2Z8d39CFrDOcrBE7muQGl+dqk4qOL610sJjkPqk4
 jxK3lOdaEOJde/HE3Rxo7rFuOBECBvfwIkrzZQm7pL/J1nUaBy
 u9mnV01b9kBki0245sdZ/qID/m7IngJ9otAFb5tWq8iMU2tdsO
 y8p9Ea+RgCJYLYsnC8Q+h7xG4mxz4mqqjN36Hw3NV4S6KvshjA
 CzOmF0ksFaZc5pdO+sGL7FnyhdRXsvUF3Qy18bC58+wj7jf6a6
 X/jZdP+YW0bqqda1Mg3gsExOzE/TNwHlmRRtCVQ36X+fE2awqt
 wKdHJ9tQ/dYOxdAyA36xtSowXEZneRFyYQBlK9xJoW/4KlPiSm
 CSodWy3IU451w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 18:59 +0100, Mike Galbraith wrote: 
> On Fri, 2012-12-21 at 17:54 +0100, Mike Galbraith wrote: 
> > On Fri, 2012-12-21 at 17:36 +0100, Mike Galbraith wrote: 
> > > On Fri, 2012-12-21 at 17:29 +0100, Thomas Gleixner wrote: 
> > > > On Fri, 21 Dec 2012, Mike Galbraith wrote:
> > > > > Just got this apocalypse day hiccup.
> > > > 
> > > > Can you revert the block chill patch ?
> > > 
> > > Sure, will do, and beat the box up a bit.
> > 
> > Hm, while I was away, box must have had a fit, then boot didn't go well.
> 
> It did that again (chill is reverted), but what it was up to prior to
> reboot was endless soft lockup.

(ie it's crashing while trying to crash dump the lockup.  poo)

