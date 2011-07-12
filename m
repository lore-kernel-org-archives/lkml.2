Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab1GLM4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 08:56:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52238 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab1GLM4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 08:56:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: Please submit platform trees for inclusion in arm-soc.git v3.1
Date: Tue, 12 Jul 2011 14:55:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, Russell King <rmk@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201107012018.14619.arnd@arndb.de> <201107112337.08892.arnd@arndb.de> <alpine.LFD.2.00.1107111815340.14596@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1107111815340.14596@xanadu.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107121455.53717.arnd@arndb.de>
X-Provags-ID: V02:K0:aOJd7wOXbMQGECqwxrKTqL26obXPj31Bd29f2vJNO4m
 e4zoz/PM26jSqdhEq8OA9eQ6uXVMXFkpqiPUiuKfQ2vw8UWQht
 ew3Z1Cx/wPunTdPtref3sBA/FJ5zLT/lnjLEoaZa4iAMB0f2bn
 FBvpEpAYdWJRyDP8AOhcEanZiXh/q1pCLaLVONSYAQ8L6ZzTIQ
 X6PyF3Kr0mhv2S7uDac/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 July 2011, Nicolas Pitre wrote:
> On Mon, 11 Jul 2011, Arnd Bergmann wrote:
> 
> > On Friday 08 July 2011, Kevin Hilman wrote:
> > > > Time is running out for the current cycle, so any changes that you
> > > > want to see merged in linux-3.1 through the arm-soc tree should be
> > > > submitted in form of pull-requests very soon.
> > > 
> > > [...]
> > > 
> > > It looks like your "remove rmk/for-next" commit may not have been
> > > totally complete.
> > > 
> > > Trying to merge your master branch and Russell's current for-next branch
> > > still results in conflicts in files that should only be touched in
> > > Russell's branch (specifically, these seem related to changes in
> > > Russell's 'suspend' branch that is included in his 'for-next' branch.)
> > 
> > Yes, that's my fault for not fixing this up correctly after initially
> > doing the incorrect pull.
> > 
> > I guess I'll throw away the current master branch and generate a new
> > one. After discussing this with Russell, I think it's best to treat
> > the master branch as temporary anyway unless Nicolas or Thomas come up
> > with a good reason against doing this.
> 
> No objections.  However, to avoid confusion, I'd suggest getting rid of 
> the branch called "master" entirely and call it something else.

Yes, makes sense.

I'll call it 'for-next' then, following the same scheme that Russell uses.
Hopefully people will take it as a hint that it's getting rebased.

	Arnd
