Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2CGKD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:03:28 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37030 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754587Ab2CGKD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:03:27 -0500
Date: Wed, 7 Mar 2012 12:03:20 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: leonid.moiseichuk@nokia.com
cc: anton.vorontsov@linaro.org, linux-kernel@vger.kernel.org,
        rientjes@google.com
Subject: RE: [PATCH] vmevent: Use 'struct vmevent_attr' for vmevent_fd()
 ABI
In-Reply-To: <84FF21A720B0874AA94B46D76DB9826904581EF7@008-AM1MPN1-003.mgdnok.nokia.com>
Message-ID: <alpine.LFD.2.02.1203071202150.1774@tux.localdomain>
References: <1331067079-2163-1-git-send-email-penberg@kernel.org> <20120306225937.GA24931@oksana.dev.rtsoft.ru> <84FF21A720B0874AA94B46D76DB9826904581EF7@008-AM1MPN1-003.mgdnok.nokia.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, leonid.moiseichuk@nokia.com wrote:
> > -----Original Message-----
> > From: ext Anton Vorontsov [mailto:anton.vorontsov@linaro.org]
> > Sent: 07 March, 2012 01:00
> > To: Pekka Enberg
> > Cc: linux-kernel@vger.kernel.org; Moiseichuk Leonid (Nokia-MP/Espoo);
> ...
> > Sorry for hijacking this thread, but speaking of big changes. Are there any
> > plans or ideas to add other methods of sampling, i.e. something not timer-
> > based?
> ...
> > Though, current vmevent seems not so lightweigh in sense of battery usage
> > and accuracy (i.e. how quick we're able to detect the crossed threshold). To
> > get better accuracy we would need to run timer at higher frequencies, but
> > then we would waste more battery.
> 
> One of patch I sent was about switching to deferred timer. This API should not be 100% accurate first, and using deferred
> timers will allow to sleep properly when system has no activity. I hope Pekka will accept the next patch as well.

I merged that patch yesterday:

http://git.kernel.org/?p=linux/kernel/git/penberg/linux.git;a=commitdiff;h=7d5e14c4b0421f7716e759934c0c2524b1d763ea

			Pekka
