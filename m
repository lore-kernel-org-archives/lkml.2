Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397Ab2CGNWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:22:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39053 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab2CGNWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:22:32 -0500
Date: Wed, 7 Mar 2012 17:22:28 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: leonid.moiseichuk@nokia.com
Cc: penberg@kernel.org, linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [PATCH] vmevent: Use 'struct vmevent_attr' for vmevent_fd() ABI
Message-ID: <20120307132228.GA30159@oksana.dev.rtsoft.ru>
References: <1331067079-2163-1-git-send-email-penberg@kernel.org>
 <20120306225937.GA24931@oksana.dev.rtsoft.ru>
 <84FF21A720B0874AA94B46D76DB9826904581EF7@008-AM1MPN1-003.mgdnok.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <84FF21A720B0874AA94B46D76DB9826904581EF7@008-AM1MPN1-003.mgdnok.nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 07:53:37AM +0000, leonid.moiseichuk@nokia.com wrote:
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

Nice idea!

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
