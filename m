Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab0FBWTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:19:41 -0400
Received: from smtp-out04.alice.it ([85.37.17.100]:1029 "EHLO
	smtp-out04.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab0FBWTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:19:39 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jun 2010 18:19:39 EDT
Date: Thu, 3 Jun 2010 00:08:28 +0200
From: Giuliano Pochini <pochini@shiny.it>
To: "F. Heitkamp" <heitkamp@ameritech.net>
Cc: alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
       linux-audio-user@lists.linuxaudio.org,
       Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
       alsa-user@lists.sourceforge.net
Subject: Re: [Alsa-user] [alsa-devel] Crash 2.6.32.x, Echo 3G, Alsa, SCSI
Message-ID: <20100603000828.04af4bdc@Jay>
In-Reply-To: <4C04FC3F.70905@ameritech.net>
References: <73211.74714.qm@web180714.mail.sp1.yahoo.com>
	<4B684513.8090201@ladisch.de>
	<20100202230911.71e8b600@Jay>
	<4C040864.8010205@ameritech.net>
	<20100531225936.4a9344df@Jay>
	<4C04FC3F.70905@ameritech.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.14.7; powerpc-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jun 2010 22:09:25.0103 (UTC) FILETIME=[42ECCFF0:01CB02A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Jun 2010 08:25:35 -0400
"F. Heitkamp" <heitkamp@ameritech.net> wrote:

> >> I've tried some newer kernels.  Still having problems with the echo 3G.
> >> This is kernel version:
> >> 2.6.32.13.  The above patches posted to the linux kernel list seemed to
> >> get rid of the crashes, but evidently did not go into the main kernel tree.
> >>      
> > Indeed. I've just checked 2.6.33 and the patch isn't there. It's in 2.6.34.
> >
> > If you need 2.6.32.13 you can apply the above patch to the kernel tree or
> > download ftp://ftp.alsa-project.org/pub/driver/alsa-driver-1.0.23.tar.bz2,
> > otherwise just use the latest kernel.
> >    
> I tried 2.6.34.   I have jack 1.9..5 installed.  I was able to use 
> rhythmbox to play mp3s.  I could not use the echomixer app.  It complained
> about a channels mismatch.

I'm running 2.6.34 now. Both a very old version of echomixer (2005!) and
the latest version I just compiled from alsa-tools-1.0.23 work fine with my
Gina3G. Please quote the error message.


> My goal is to be able to plug in a MIDI keyboard, or USB guitar 
> interface and play along with songs etc.
> 
> I plugged in a MIDI keyboard, "/proc/asound/cards" showed the keyboard 
> was recognized.  The keyboard has a USB and MIDI interface.
> I am not sure if they both work at the same time.  I had the MIDI cable 
> plugged into the Gina3G, but I could not tell if the keyboard was 
> recognized.
> I compiled csound5.  When I engaged it the system immediately froze and 
> started spitting out:
> [...]

Ok, I compiled csound, but I don't know how to use it. How can I reproduce
the problem ?


-- 
Giuliano.
