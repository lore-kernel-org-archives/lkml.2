Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab0EZQWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:22:18 -0400
Received: from mx2.sophos.com ([195.166.81.53]:43547 "EHLO mx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab0EZQWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:22:16 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: David Rientjes <rientjes@google.com>
Subject: Re: 2.6.33.2 kmalloc-8 slab leaks ~512 objects per second
Date: Wed, 26 May 2010 17:22:14 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc7; KDE/4.3.5; x86_64; ; )
CC: Catalin Marinas <catalin.marinas@arm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Airlie <airlied@linux.ie>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Jerome Glisse <glisse@freedesktop.org>
References: <201005121121.49135.tvrtko.ursulin@sophos.com> <201005131339.32113.tvrtko.ursulin@sophos.com> <alpine.DEB.2.00.1005260220460.8417@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1005260220460.8417@chino.kir.corp.google.com>
MIME-Version: 1.0
Message-ID: <201005261722.14252.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 26/05/2010 17:22:14,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 26/05/2010 17:22:15,
	Serialize complete at 26/05/2010 17:22:15
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 May 2010 10:21:36 David Rientjes wrote:
> On Thu, 13 May 2010, Tvrtko Ursulin wrote:
> > > You could just enable CONFIG_DEBUG_KMEMLEAK on 2.6.33, mount the
> > > debugfs and do a 'cat /sys/kernel/debug/kmemleak' after a half-hour or
> > > so.
> >
> > I could do it if radeon/drm guys would be interested in those results?
> > (Given how 2.6.34-rc7 is not leaking.)
>
> Did you get a chance to find out if kmemleak was able to identify the
> source of this problem?

Well no, I asked DRM/radeon guys to explicitly say whether it would be useful,
otherwise it is unfortunately sufficiently low on my priority list that it
will probably never happen.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
