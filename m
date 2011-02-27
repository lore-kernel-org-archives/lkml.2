Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab1B0HIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 02:08:49 -0500
Received: from swm.pp.se ([212.247.200.143]:34082 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab1B0HIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 02:08:46 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Feb 2011 02:08:46 EST
Date: Sun, 27 Feb 2011 08:02:03 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Albert Cahalan <acahalan@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: txqueuelen has wrong units; should be time
In-Reply-To: <AANLkTimd5GQwtUFP2fD_An=M8ajBD8DJpzxQJezv8fB8@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.1102270758580.11974@uplift.swm.pp.se>
References: <AANLkTimd5GQwtUFP2fD_An=M8ajBD8DJpzxQJezv8fB8@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Feb 2011, Albert Cahalan wrote:

> Nanoseconds seems fine; it's unlikely you'd ever want
> more than 4.2 seconds (32-bit unsigned) of queue.

I think this is shortsighted and I'm sure someone will come up with a case 
where 4.2 seconds isn't enough. Let's not build in those kinds of 
limitations from start.

Why not make it 64bit and go to picoseconds from start?

If you need to make it 32bit unsigned, I'd suggest to start from 
microseconds instead. It's less likely someone would want less than a 
microsecond of queue, than someone wanting more than 4.2 seconds of queue.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
