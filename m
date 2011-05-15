Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027Ab1EON5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 09:57:09 -0400
Received: from keil-draco.com ([216.193.185.50]:42534 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab1EON5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 09:57:07 -0400
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 May 2011 09:57:07 EDT
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: 2.6.39-rc7 nouveau vs KDE 4.6.2
Date: Sun, 15 May 2011 09:47:38 -0400
User-Agent: KMail/1.13.6 (Linux/2.6.38-sabayon; KDE/4.6.2; x86_64; ; )
Cc: bskeggs@redhat.com, linux-kernel@vger.kernel.org,
        nouveau@lists.freedesktop.org
References: <20110514231208.GA2947@p183> <20110515080929.GA2533@p183> <20110515082137.GA3882@p183>
In-Reply-To: <20110515082137.GA3882@p183>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105150947.38329.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 15, 2011 04:21:37 AM Alexey Dobriyan wrote:
> On Sun, May 15, 2011 at 11:09:29AM +0300, Alexey Dobriyan wrote:
> > On Sun, May 15, 2011 at 02:12:08AM +0300, Alexey Dobriyan wrote:
> > > After logging into KDE, I get garbage areas when say mouse moves over
> > > icon in tray, or when window is opened fullscreen to the point it's
> > > unusable.
> > > 
> > > Previous version of KDE (4.4.5?) was OK.
> > > 
> > > 
> > > Linux version 2.6.39-rc7 (ad@p183) (gcc version 4.4.5 (Gentoo 4.4.5
> > > p1.2, pie-0.4.5) ) #4 SMP PREEMPT Tue May 10 22:07:32 EEST 2011
> > 
> > FYI, 2.6.38.5 is no different.
> 
> Disable compositing/"desktop effects" (alt+shift+F12) works except
> switch to fbconsole and back leaves screen black.

(sorry if some of you get this double - I forgot to hit "reply all" when I 
first replied...)

I've come across a similar bug with the binary blob driver from nvidia - and 
compositing state doesn't matter. The fbconsole switch leaves that system with 
an image of the desktop, but said image is non-responsive. In the case of an 
application or game that was running in a fullscreen window it will lose some 
events and generally get stuck non-working and showing nothing. After seeing 
the report of problems with the fbcon switch (I've also seen some artifacting 
and/or "garbage" with the binary blob) I'm wondering if there might not be a 
hardware bug that nvidia manages to paper-over in the windows version of the 
driver that nouveau and the ugly binary-blob are unable to miss in Linux...

DRH
