Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936333Ab0CONvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:51:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936249Ab0CONvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:51:13 -0400
Date: Mon, 15 Mar 2010 14:51:11 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, wylda@volny.cz,
       Pavel Machek <pavel@suse.cz>,
       Alessandro Guido <ag@alessandroguido.name>,
       Tomas Hanak <tomas.hanak@gmail.com>, Jason Noble <nobleja@polezero.com>,
       simon.windows@gmail.com, Sean Hildebrand <silverwraithii@gmail.com>,
       Sid Boyce <sboyce@blueyonder.co.uk>, Henning Glawe <glaweh@debian.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Added locks for sysfs attributes and internal
 data.
In-Reply-To: <20100314084215.GA8226@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1003151449050.18642@pobox.suse.cz>
References: <201002200911.53900.stefan_achatz@web.de> <201003081704.30119.stefan_achatz@web.de> <20100309074155.GA17288@core.coreip.homeip.net> <201003131219.27482.erazor_de@users.sourceforge.net> <20100314084215.GA8226@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Mar 2010, Dmitry Torokhov wrote:

> > 3. grow up of driver
> > I see my work is not quite ready for kernel inclusion. Maybe I'm wrong in this 
> > list and should bug other people. Would the linuxdriverproject.org be a 
> > better place to raise my work to adulthood?
> > 
> Rarely a driver is ready for inclusion right away ;) Normally that 
> happens after someone submitted a few of them to the same subsystem so 
> he knows maintainers perferences, etc. I'd say you are doing well as is 
> here, there is no sense to move away somewhere else at this point.

Absolutely.

Stefan, you are handling the review feedback in an excellent way, and the 
driver is very quickly getting into shape in which it would be merge-able 
right away.

So please do another round of submission with all the concerns that have 
been raised previously addressed, and I believe I'll just apply the driver 
to my tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
