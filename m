Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2ANDZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 22:25:36 -0500
Received: from hades.mikemestnik.net ([184.106.158.151]:49856 "EHLO
	hades.mikemestnik.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab2ANDZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 22:25:34 -0500
X-Greylist: delayed 510 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jan 2012 22:25:34 EST
Message-ID: <4F10F3AE.3030801@mikemestnik.net>
Date: Fri, 13 Jan 2012 21:17:02 -0600
From: Mike Mestnik <cheako@mikemestnik.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0) Gecko/20111223 Thunderbird/10.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Chronic resource starvation.
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've dealt with applications taking extended time off for a number of
years.  I typically attribute it to applications being overly zealous
about eating memory as most every application tends to do these days.  I
had always figured that there a likely plenty of ppl complaining and I
didn't want to get the boiler plat answer that resources are cheap.

I refuse to buy into the idea that Z computers can get an additional Y
resource to run application X, when instead application X could be
engineered once and for all.  This ideology is not sustainable and
eventually will crash upon it's self.  I call this Z * Y < X.  The
application source becomes the single location where every computers
resources can be increased at the cost of much less then to adjust the
running environment of every location that the code may run.

Here is a 84MB video that demonstrates the issue.
http://j.mp/wavbCO
http://bitly.com/wavbCO+

You can see at the start an application that should update regularly is
frozen and that moving windows and even focus is difficult.  The system
does recover, but after far too long.

I'll welcome any further testing as I'm sure it's needed.  Keep in mind
that I can't reproduce this reliably, but it does happen, so it will
take time to collect any amount of data...  A gkrellm plugin that
illustrates the test is the most perfered, killing two birds with one
stone as it will help with this case and many many future cases.  If
it's important wouldn't your test already be part of a tool like gkrellm?

