Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab3AJBHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 20:07:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:3373 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932323Ab3AJBHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 20:07:43 -0500
Message-Id: <b94cdc$83e88b@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,440,1355126400"; 
   d="scan'208";a="272048395"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: i915_hangcheck_hung problem with 3.8-rc2+ (Linus's latest tree)
To: Greg KH <gregkh@linuxfoundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Lijo Antony <lijo.kernel@gmail.com>, Dave Airlie <airlied@gmail.com>,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <20130110004025.GB11605@kroah.com>
References: <20130108223611.GA19672@kroah.com> <20130109003824.GA21075@kroah.com> <CAPM=9tw3o0e_3cRUFntwddxsWMsYkVKe1b5gDQhxijYKU=9m5g@mail.gmail.com> <20130109042533.GA9164@kroah.com> <CAPM=9tyB4aKK2Z3-h9yEXLWvrnKGjxH2DaOHp8uA0mNNZQiVWQ@mail.gmail.com> <50ED1C12.2090608@gmail.com> <50EDC8A1.30307@oracle.com> <50EDCF14.4080101@oracle.com> <20130110004025.GB11605@kroah.com>
Date: Thu, 10 Jan 2013 01:07:33 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2013 16:40:25 -0800, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Jan 09, 2013 at 02:12:04PM -0600, Dave Kleikamp wrote:
> > On 01/09/2013 01:44 PM, Dave Kleikamp wrote:
> > > 
> > > I can easily reproduce it running glxgears on 3.8-rc1 or 3.8-rc2.
> > > 
> > > 00:02.0 VGA compatible controller [0300]: Intel Corporation Core
> > > Processor Integrated Graphics Controller [8086:0046] (rev 02)
> > > 
> > > Thinkpad T410
> > > 
> > > Shaggy
> > 
> > Daniel's patch:
> > 
> > drm/i915: Revert shrinker changes from "Track unbound pages"
> > 
> > fixes the problem for me.
> 
> After an afternoon of multiple kernel builds and other stressful things,
> it looks like it fixes it for me as well.  Chris, this will be going to
> Linus soon, right?

Daniel will send it on. I hope before he does so, he will clarify the
changelog to note that it is just papering over the issue. If the
conjecture is right, it will not prevent that path from triggering the
hang, nor does it prevent other eviction paths from potentially causing
the same issue.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
