Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab1HJN4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 09:56:48 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:41868 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751690Ab1HJN4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 09:56:46 -0400
Subject: Re: [ANNOUNCE] 3.0-rt1
From: "Peter W. Morreale" <pmorreale@novell.com>
Reply-To: pmorreale@novell.com
To: Mike Galbraith <efault@gmx.de>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1312953290.5395.39.camel@marge.simson.net>
References: <alpine.LFD.2.02.1107222203400.2702@ionos>
	 <4E2A1E75.4070709@gmail.com> <1311428078.2502.0.camel@hermosa.morreale.net>
	 <1312953290.5395.39.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Organization: LSG - Novell Inc.
Date: Wed, 10 Aug 2011 07:56:39 -0600
Message-ID: <1312984599.2547.10.camel@hermosa.morreale.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 07:14 +0200, Mike Galbraith wrote:
> On Sat, 2011-07-23 at 07:34 -0600, Peter W. Morreale wrote:
> > On Sat, 2011-07-23 at 03:05 +0200, Maarten Lankhorst wrote:
> 
> > > Only the nvidia driver fails to build because of rtmutex and migrate enable/disable being GPL only, you might want to reconsider the GPL only status of them.
> > > 
> > > ~Maarten
> > 
> > Or, alternatively, please ask Nvidia to GPL their driver.
> 
> I know a couple folks for whom this will eventually become a problem.
> 
> One is doing (very) high performance aircraft simulation, where
> rendering performance highly important.  AFAIK there is currently no
> viable alternative to "the blob"
> 
> 	-Mike
> 

Great!  Perhaps they can talk to Nvidia as well.  

Best,
-PWM

