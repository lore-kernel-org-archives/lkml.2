Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab1HJFOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 01:14:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56940 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750857Ab1HJFOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 01:14:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/h2C9/G/fhLEmWECs4+qpDLwSB43oeu9uBpTzW5z
	5rtoNlSSmME3Db
Subject: Re: [ANNOUNCE] 3.0-rt1
From: Mike Galbraith <efault@gmx.de>
To: pmorreale@novell.com
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1311428078.2502.0.camel@hermosa.morreale.net>
References: <alpine.LFD.2.02.1107222203400.2702@ionos>
	 <4E2A1E75.4070709@gmail.com> <1311428078.2502.0.camel@hermosa.morreale.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 07:14:50 +0200
Message-ID: <1312953290.5395.39.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-23 at 07:34 -0600, Peter W. Morreale wrote:
> On Sat, 2011-07-23 at 03:05 +0200, Maarten Lankhorst wrote:

> > Only the nvidia driver fails to build because of rtmutex and migrate enable/disable being GPL only, you might want to reconsider the GPL only status of them.
> > 
> > ~Maarten
> 
> Or, alternatively, please ask Nvidia to GPL their driver.

I know a couple folks for whom this will eventually become a problem.

One is doing (very) high performance aircraft simulation, where
rendering performance highly important.  AFAIK there is currently no
viable alternative to "the blob"

	-Mike

