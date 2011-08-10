Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab1HJF2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 01:28:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab1HJF2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 01:28:07 -0400
Subject: Re: [ANNOUNCE] 3.0-rt1
From: Mike Galbraith <mgalbraith@suse.de>
To: pmorreale@novell.com
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1312953290.5395.39.camel@marge.simson.net>
References: <alpine.LFD.2.02.1107222203400.2702@ionos>
	 <4E2A1E75.4070709@gmail.com> <1311428078.2502.0.camel@hermosa.morreale.net>
	 <1312953290.5395.39.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 07:28:03 +0200
Message-ID: <1312954083.5395.41.camel@marge.simson.net>
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

(maybe one of them will buy nvidia, and GPL the driver.. right:)

