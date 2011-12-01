Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab1LAU2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 15:28:12 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35079 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657Ab1LAU2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 15:28:11 -0500
Date: Thu, 1 Dec 2011 21:29:10 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: patrik.r.jakobsson@gmail.com, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: GMA500 support
Message-ID: <20111201202909.GB7825@Boggieman>
Reply-To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
References: <20111121182910.GA2856@Boggieman>
 <20111123112847.57c20f8f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111123112847.57c20f8f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 11:28:47AM +0000, Alan Cox wrote:
> On Mon, 21 Nov 2011 19:29:10 +0100
> Kristoffer Ericson <kristoffer.ericson@gmail.com> wrote:
> 
> > Greetings,
> > 
> > Im syncing my gma500 tree to all the patches I see pass through the kernel mailinglist and
> > its progressing well. 
> > However, It would be nice with an todo list or a more practical this-works list. I know
> > its not a priority but would simplify alot for end users.
> 
> If you configure it in the following should work on GMA500/600
> - internal laptop displays including backlight
> - external svga
> - mode setting via KMS
> - framebuffer console
> - the framebuffer X server (and once out generally Dave Airlie's generic
>   KMS X server)
> - suspend/resume
> 
> The following I know don't work
> - Huge external displays so large they won't fit in 8MB at init time
>   (causes a crash)
> - Using the vesa X server with it - this confuses stuff and isn't
>   fixable, it's a "wrong user configuration"
> 
> Unsupported
> - 2D hardware acceleration except console scrolling (as it seems to be
>   too slow to be useful). I may add some 2D bits later where they do help
>   (eg back to front blitting may be worth it just about)
> - 3D engine (no public documentation)

I understand that the chip is powerv SGX 535, any likelyhood of
getting those datasheets opened by the company?

> - Video playback acceleration. In theory there is enough info in the
>   VAAPI code for GMA500/600 that has been published and in the old
>   'binary X/source kernel' driver to do this but someone will have to
>   work on it if they want it
> - Dell Mini HDMI port. This seems to be some kind of external bridge
>   chip. Being a TV luddite I don't yet own an HDMI capable display to
>   test.
> 
> And I'm sure we have a few bugs left !
> 
> Alan
