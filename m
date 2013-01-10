Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab3AJAj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 19:39:56 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:60478 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab3AJAjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 19:39:55 -0500
Date: Wed, 9 Jan 2013 16:40:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Lijo Antony <lijo.kernel@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: i915_hangcheck_hung problem with 3.8-rc2+ (Linus's latest tree)
Message-ID: <20130110004025.GB11605@kroah.com>
References: <20130108223611.GA19672@kroah.com>
 <20130109003824.GA21075@kroah.com>
 <CAPM=9tw3o0e_3cRUFntwddxsWMsYkVKe1b5gDQhxijYKU=9m5g@mail.gmail.com>
 <20130109042533.GA9164@kroah.com>
 <CAPM=9tyB4aKK2Z3-h9yEXLWvrnKGjxH2DaOHp8uA0mNNZQiVWQ@mail.gmail.com>
 <50ED1C12.2090608@gmail.com>
 <50EDC8A1.30307@oracle.com>
 <50EDCF14.4080101@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EDCF14.4080101@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 02:12:04PM -0600, Dave Kleikamp wrote:
> On 01/09/2013 01:44 PM, Dave Kleikamp wrote:
> > 
> > I can easily reproduce it running glxgears on 3.8-rc1 or 3.8-rc2.
> > 
> > 00:02.0 VGA compatible controller [0300]: Intel Corporation Core
> > Processor Integrated Graphics Controller [8086:0046] (rev 02)
> > 
> > Thinkpad T410
> > 
> > Shaggy
> 
> Daniel's patch:
> 
> drm/i915: Revert shrinker changes from "Track unbound pages"
> 
> fixes the problem for me.

After an afternoon of multiple kernel builds and other stressful things,
it looks like it fixes it for me as well.  Chris, this will be going to
Linus soon, right?

thanks,

greg k-h
