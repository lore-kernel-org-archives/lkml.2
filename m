Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab0KHLin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:38:43 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:54570 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab0KHLim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:38:42 -0500
Subject: Re: [bisected] offset display bug in i915
From: Jon Masters <jonathan@jonmasters.org>
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTinOeu28+uJ=4KwKtn5CPZJyo=VuyhvuNUOgbe+L@mail.gmail.com>
References: <1289211512.3916.383.camel@constitution.bos.jonmasters.org>
	 <b9dded$h0q3am@orsmga002.jf.intel.com>
	 <1289213695.3916.396.camel@constitution.bos.jonmasters.org>
	 <AANLkTinOeu28+uJ=4KwKtn5CPZJyo=VuyhvuNUOgbe+L@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 08 Nov 2010 06:38:55 -0500
Message-ID: <1289216335.3916.407.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 11:33 +0000, James Courtier-Dutton wrote:
> On 8 November 2010 10:54, Jon Masters <jonathan@jonmasters.org> wrote:
> >
> > Here is the EDID output after booting:
> >
> > [jcm@monticello ~]$ hexdump /sys/class/drm/card0-LVDS-1/edid
> > 0000000 ff00 ffff ffff 00ff 6422 03e9 8544 0001
> > 0000010 141c 0301 1680 780d 860a 9426 5157 2790
> > 0000020 4f21 0054 0000 0101 0101 0101 0101 0101
> > 0000030 0101 0101 0101 1194 b000 5840 2019 2335
> > 0000040 0045 81dc 0000 1900 1416 d800 5840 2026
> > 0000050 235d 0415 81dc 0000 0000 0000 fe00 0000
> > 0000060 0000 0000 0000 0000 0000 0000 0000 fe00
> > 0000070 0000 0000 0000 0000 0100 0000 0000 f200
> > 0000080
> >
> hexdump -C  is a little easier to read and compare with other hexdumps.

Yea, but I already ran edid-decode for Chris.

Chris: I suggest your idea of hacking up edid-decode to also take
hexdumps is a good idea for the future. That way you can feed it the
output from xrandr, or from people who like me don't realize that it's
preferred to post the interpreted output.

Jon.


