Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab2FJLWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 07:22:42 -0400
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:19237 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab2FJLWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 07:22:39 -0400
Message-ID: <4FD4837B.5040200@free.fr>
Date: Sun, 10 Jun 2012 13:22:35 +0200
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120418 Icedove/11.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 3.2.19 kernel panic does not enter KDB
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm currently chasing a kernel panic (dual keyboard led actually 
blinking) when playing HD using XBMC on a debian unstable X86_64 
distribution.

I'm stuck with 3.2.X kernel line until maintainer of dvbhdhomerun 
integrates 3.3 DVB api changes.

I'm stuck to nvidia 302.x because this is the only nvidia driver version 
that supports xrandr and XBMC does not support nvidia proprietary 
protocol that replaces xrandr for refresh rate selection...

Its probably dues to a bad interaction between nvidia driver/vdpau/XBMC 
because VLC can play same content without panicking but with vaapi 
acceleration API instead of VDPAU.

I have a working KGDB/KDB setup (at least hitting ALT SYST q on a tty 
show KDB help). I still get the blinking led without entering KDB. When 
video freeze, I get the a fix video image, a audio loop and the blinking 
leds but cannot get access to KDB console. Any hint?

PS: please CC me I'm not subscribed.

--eric
