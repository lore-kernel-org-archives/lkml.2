Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab1KBRQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:16:31 -0400
Received: from avasout06.plus.net ([212.159.14.18]:59596 "EHLO
	avasout06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab1KBRQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:16:30 -0400
X-CM-Score: 0.00
X-CNFS-Analysis: v=2.0 cv=SZl1h4tu c=1 sm=1 a=F8hxLa1Qgym6LBeQ3hiSHg==:17
 a=9GetC4Mfny8A:10 a=8nJEP1OIZ-IA:10 a=pGLkceISAAAA:8 a=g_0wNEBgAAAA:8
 a=cAi9g3XxU3nv95FBJOoA:9 a=wPNLvfGTeEIA:10 a=MSl-tDqOz04A:10
 a=F8hxLa1Qgym6LBeQ3hiSHg==:117
Date: Wed, 2 Nov 2011 17:08:58 +0000
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: "Sergey S. Kostyliov" <rathamahata@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: HDA Intel microphone regression in 3.1.0
Message-ID: <20111102170858.35aa9831@laptop.homenet>
In-Reply-To: <CA+QCeVRFsh0_q3E-B6GWyGQgWOe4VhMkPNLuQLAL-YvEVRA8jA@mail.gmail.com>
References: <20111102102554.1f443b9c@laptop.homenet>
	<CA+QCeVRFsh0_q3E-B6GWyGQgWOe4VhMkPNLuQLAL-YvEVRA8jA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Nov 2011 14:40:44 +0200
"Sergey S. Kostyliov" <rathamahata@gmail.com> wrote:
> On 2 November 2011 12:25, Chris Vine <chris@cvine.freeserve.co.uk>
> wrote:
> > My Lenovo S12 IdeaPad netbook uses a HDA Intel sound card with
> > Realtek ALC269 chip.  With the 3.1.0 kernel, all microphone input
> > (both with the internal microphone and any external microphone) is
> > permanently muted, although sound output works OK.  Microphone
> > input works correctly with the 3.0 and earlier kernels.
> Could you please say do you have CONFIG_SND_HDA_GENERIC == y ?
> I had experienced the same problem with CONFIG_SND_HDA_GENERIC = y
> Turning it off it cured the problem for me.
[snip]

I did have that configuration option chosen, but if I turn it off I
still get the same problem unfortunately.

Chris
