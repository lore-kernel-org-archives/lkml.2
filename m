Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab0F1Rbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 13:31:42 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43760 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab0F1Rbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 13:31:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ZHXBWhHv9CSxojvfCJ7++WORizeZfdwp78TbfyhT/dTMDkgiRhvw8PImrpptYaKU1U
         My++rY8Dg5ImCCOlMtcspPsZekcj8ZqWWg4x/gzVLNAOtYLHI3SAg6BhdArFMXn1Hkf2
         w/brRTiXGtN7FITrSROxtsUGJyPTn8jObLW+E=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Subject: Re: Regression: ps2mouse not working in 2.6.34
Date: Mon, 28 Jun 2010 10:31:31 -0700
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <4C28C81E.4010909@teksavvy.com> <20100628163350.GA11670@core.coreip.homeip.net> <4C28D96B.6060409@teksavvy.com>
In-Reply-To: <4C28D96B.6060409@teksavvy.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006281031.32568.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 28, 2010 10:18:35 am Mark Lord wrote:
> On 28/06/10 12:33 PM, Dmitry Torokhov wrote:
> > On Mon, Jun 28, 2010 at 12:04:46PM -0400, Mark Lord wrote:
> >> Okay, who broke it, and how do I re-enable it?
> >> 
> >> The PS/2 mice on my systems here don't do anything with 2.6.34.
> >> One system complains that I need to boot with i8042.nopnp to enable it,
> >> which I also tried, but still nogo.  Same behaviour with or without
> >> /dev/psaux enabled.  64-bit kernel.
> >> 
> >> The other system, running older userspace, hangs at the X-server startup
> >> because it cannot find the mouse.  No i8042 warnings.   32-bit kernel.
> >> 
> >> Both systems working fine with older kernels.
> >> Google finds lots of other people discovering the same problem.
> >> 
> >> What gives?
> > 
> > Well, lest start small: did it work ifor you with 2.6.33? Does kernel
> > discover AUX serio port (dmesg)? What about the mouse itself? Is it
> > absent or is it not reporting events?
> 
> ..
> 
> I started by crawling into the wire nest under the table.  :)
> 
> After a certain amount of experimentation, it appears that the newer
> kernel is not compatible with the USB-to-PS2 dongle on the end of the
> mouse. I found a different USB-to-PS2 dongle which does work, though.
> 
> Very weird.  I can mail you the other dongle if are really interested
> in figuring out what broke and fixing it.

Hmm, let me dig out one of my dongles first and see if it is broken too... If 
not I might be interested in getting yours but no promises - time is tight ;(

Thanks.

-- 
Dmitry
