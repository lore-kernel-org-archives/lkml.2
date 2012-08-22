Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab2HVFt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:49:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46712 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab2HVFtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:49:25 -0400
Date: Tue, 21 Aug 2012 22:49:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Simon Budig <simon.budig@kernelconcepts.de>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: Let the FT5x06 driver build without debugfs
Message-ID: <20120822054919.GB20624@core.coreip.homeip.net>
References: <87k3wy1ii3.fsf@xmission.com>
 <502DFC1D.20903@kernelconcepts.de>
 <87boi91g01.fsf@xmission.com>
 <20120820135303.GA9278@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820135303.GA9278@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 06:53:03AM -0700, Guenter Roeck wrote:
> On Fri, Aug 17, 2012 at 12:21:34PM -0700, Eric W. Biederman wrote:
> > Simon Budig <simon.budig@kernelconcepts.de> writes:
> > 
> > > On 08/17/2012 02:15 AM, Eric W. Biederman wrote:
> > >> When testing to make certain my user namespace code works in
> > >> various configurations I tripped over the tf5x06.c not building
> > >> with debugfs disabled.
> > >
> > > Sorry for that.
> > >
> > > There already is a patch for this issue which I slightly prefer. You
> > > can find it in the mail from Guenther Roeck:
> > >    http://www.mail-archive.com/linux-input@vger.kernel.org/msg00646.html
> > 
> > If you guys could get that merged into 3.6 I would appreciate it.
> > 
> Yes, that would be great. I don't recall seeing an e-mail from Dmitry accepting
> it, though.

Applied, sorry for the delay.

-- 
Dmitry
