Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab0LANEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 08:04:09 -0500
Received: from ee.oulu.fi ([130.231.61.23]:34666 "EHLO ees2.oulu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab0LANEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 08:04:07 -0500
X-Greylist: delayed 2644 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Dec 2010 08:04:07 EST
From: Pekka Pietikainen <pp@ee.oulu.fi>
Date: Wed, 1 Dec 2010 14:19:57 +0200
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: low overhead packet capturing on linux
Message-ID: <20101201121957.GA3747@ee.oulu.fi>
References: <201011301728.05197.thomas@fjellstrom.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201011301728.05197.thomas@fjellstrom.ca>
zFrom: Pekka Pietikainen <pp@ee.oulu.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 05:28:05PM -0700, Thomas Fjellstrom wrote:
> I'm working on a little tool to monitor and measure bandwidth use on a vm 
> host, down to keeping track of all guest and host bandwidth, including, 
> eventually per layer7 protocol use.
> 
> Right now I have a pretty simple setup, I setup an AF_PACKET socket, select on 
> it, and read data as it comes in. Obviously, this has a fatal flaw. It takes up 
> a rather large amount of cpu time just to capture the packets. On a GbE 
> interface, it uses up easily 60-80% cpu (on a 2.6Ghz amd phenom II cpu core) 
> just to capture the packets, trying to do anything fancy with them will likely 
> cause the kernel to drop some packets.
> 
> So what I'm looking for is a very low overhead way to capture packets. I've 
> come up with a few ideas, some of which I have no idea if they'd even work.
Have you checked out

http://public.lanl.gov/cpw/ (IIRC it's actually a part of recent libpcap,
but could be wrong) and http://www.ntop.org/PF_RING.html ?

