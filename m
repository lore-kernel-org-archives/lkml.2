Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab2G3F4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 01:56:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47612 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab2G3F42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 01:56:28 -0400
Date: Sun, 29 Jul 2012 22:56:23 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Yann Cantin <yann.cantin@laposte.net>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH 3/3] input: misc: New USB eBeam input driver.
Message-ID: <20120730055623.GD5830@core.coreip.homeip.net>
References: <1343433754-3887-1-git-send-email-yann.cantin@laposte.net>
 <1343433754-3887-4-git-send-email-yann.cantin@laposte.net>
 <20120728014252.GB19817@core.coreip.homeip.net>
 <5013AA95.7090006@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5013AA95.7090006@laposte.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2012 at 11:02:13AM +0200, Yann Cantin wrote:
> Hi Dmitry,
> 
> >> +config INPUT_EBEAM_USB_CLASSIC
> >> +	bool "eBeam Classic Projection support"
> >> +	depends on INPUT_EBEAM_USB
> >> +	default y
> > 
> > Will there be support for other eBean devices (are there any)? If there
> > will how soon? How different are they? If not the we probably do not
> > need this INPUT_EBEAM_USB_CLASSIC selector.
> 
> I know at least one re-branded same hardware by 3M, i will be able to borrow
> one in a month or so. According to the wikipedia article, there's probably more.
> 
> There's also newer models and embeded ones in some video projector setup, also
> re-branded, based on the same technology and that might use the same type of
> protocol, but i can't be sure until someone can inspect them.
> These pieces of hardware are quite expensive, and mostly used in educational
> or corporate, they are not easy to grab.
> 
> The code structure (device selector + functions indirection) also seems overkill
> to me for now, but permit to anticipate device's variations. If it appears that they
> all works in the same way, it'll be easy (and more comfortable to me) to step down,
> the opposite seems more difficult.

Actually I am hesitant to add infrastructure if it is unclear if we need
it at all.

Thanks.

-- 
Dmitry
