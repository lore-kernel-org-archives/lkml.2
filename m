Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab1GIGaQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:30:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58581 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab1GIGaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:30:11 -0400
Date: Sat, 9 Jul 2011 16:29:48 +1000
From: Robert Swan <swan.r.l@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [bisected] pty performance problem
Message-ID: <20110709062948.GA8093@swanrl.gmail.com>
Reply-To: swan.r.l@gmail.com
References: <20091121222319.GA3905@swanrl.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20091121222319.GA3905@swanrl.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 22, 2009 at 09:23:19AM +1100, Robert Swan wrote:
> I posted this to the kernel-newbies list, but have graduated to the
> adults forum:
> 
> ! Two C programs are having a query-response conversation through a
> ! pseudo terminal:
> ! 
> ! A (client) -- forever { send query; read response }
> ! B (server) -- forever { read query; send response }
> ! 
> ! Neither has any I/O apart from the pty conversation, so I'd expect to
> ! see CPU usage at 100%. When I ran it, the CPU was pretty well idle.
> ! After a fair bit of fiddling, it turned out that both sides were
> ! taking about 8ms for their read() calls. At that point it seemed
> ! pretty clear that this was a delay in the kernel, not the code.
> ! 
> [snip]
> 
> 2.6.31-rc2-00205-gb4b21ca good
> 2.6.31-rc2-00206-gd945cb9 bad
> 
> and still bad with the latest: 2.6.32-rc8-00011-ga8a8a66

And still bad with the 2.6.37 release.

I have been using a workaround happily enough, so I'm not nagging.
18 months hardly rates as nagging frequency, possibly sniping, but I'm
not doing that either.  I tried my test case for the first time in
ages today and thought a reminder was merited in case it had slipped
between the cracks.

I'll attach the test code, since I didn't post that to the list last
time.

Have fun,

Rob.

--YiEDa0DAkWCtVeE4
Content-Type: application/x-gtar
Content-Disposition: attachment; filename="ptytst.tgz"
Content-Transfer-Encoding: base64

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

--YiEDa0DAkWCtVeE4--
