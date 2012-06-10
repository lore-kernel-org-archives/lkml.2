Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab2FJLal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 07:30:41 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51485 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab2FJLak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 07:30:40 -0400
Date: Sun, 10 Jun 2012 12:34:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: eric.valette@free.fr
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.2.19 kernel panic does not enter KDB
Message-ID: <20120610123420.52af4e1a@pyramind.ukuu.org.uk>
In-Reply-To: <4FD4837B.5040200@free.fr>
References: <4FD4837B.5040200@free.fr>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2012 13:22:35 +0200
Eric Valette <eric.valette@free.fr> wrote:

> Hi,
> 
> I'm currently chasing a kernel panic (dual keyboard led actually 
> blinking) when playing HD using XBMC on a debian unstable X86_64 
> distribution.
> 
> I'm stuck with 3.2.X kernel line until maintainer of dvbhdhomerun 
> integrates 3.3 DVB api changes.
> 
> I'm stuck to nvidia 302.x because this is the only nvidia driver version 
> that supports xrandr and XBMC does not support nvidia proprietary 
> protocol that replaces xrandr for refresh rate selection...
> 
> Its probably dues to a bad interaction between nvidia driver/vdpau/XBMC 
> because VLC can play same content without panicking but with vaapi 
> acceleration API instead of VDPAU.
> 
> I have a working KGDB/KDB setup (at least hitting ALT SYST q on a tty 
> show KDB help). I still get the blinking led without entering KDB. When 
> video freeze, I get the a fix video image, a audio loop and the blinking 
> leds but cannot get access to KDB console. Any hint?

I think you are on the wrong list. Nvidia have kernel source code, we
don't have code to their proprietary stuff. Only they can help you.

It's quite possible the box is hanging so hard that kdb can't help you.
In that case you'll again need someone with their proprietary Nvidia
source to help you.

Alan
