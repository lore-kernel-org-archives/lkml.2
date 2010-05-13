Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab0EMMjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 08:39:36 -0400
Received: from mx4.sophos.com ([74.202.89.161]:53454 "EHLO mx4.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab0EMMjf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 08:39:35 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: 2.6.33.2 kmalloc-8 slab leaks ~512 objects per second
Date: Thu, 13 May 2010 13:39:31 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc7; KDE/4.3.5; x86_64; ; )
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Airlie <airlied@linux.ie>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Jerome Glisse <glisse@freedesktop.org>
References: <201005121121.49135.tvrtko.ursulin@sophos.com> <201005121404.49720.tvrtko.ursulin@sophos.com> <tnxiq6sm1c2.fsf@e102109-lin.cambridge.arm.com>
In-Reply-To: <tnxiq6sm1c2.fsf@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Message-ID: <201005131339.32113.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 13/05/2010 13:39:32,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 13/05/2010 13:39:33,
	Serialize complete at 13/05/2010 13:39:33
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 May 2010 13:29:49 Catalin Marinas wrote:
> Tvrtko Ursulin <tvrtko.ursulin@sophos.com> wrote:
> > On Wednesday 12 May 2010 14:00:51 Pekka Enberg wrote:
> >> [snip]
> >>
> >> You might want to try out the built-in kernel memory leak detector.
> >> See Documentation/kmemleak.txt for details how to enable it and use
> >> it.
> >
> > Thanks for the suggestion, I will have to try it out once but not this
> > time :) because 2.6.34-rc7 seems to be fine, or in other words not
> > leaking.
>
> You could just enable CONFIG_DEBUG_KMEMLEAK on 2.6.33, mount the debugfs
> and do a 'cat /sys/kernel/debug/kmemleak' after a half-hour or so.

I could do it if radeon/drm guys would be interested in those results? (Given
how 2.6.34-rc7 is not leaking.)

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
