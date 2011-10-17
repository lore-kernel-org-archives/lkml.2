Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab1JQRHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:07:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35808 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab1JQRHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:07:02 -0400
X-Authority-Analysis: v=1.1 cv=cRnbtTsVO6wWDdOYuq0VmyuiiLG/FStMSb4CWlTvuS0= c=1 sm=0 a=oe0lC-8eqlkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=QBd8sib8kbf3jmWGdp8A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1318871219.12224.138.camel@gandalf.stny.rr.com>
Subject: Re: Problems with videos and i915 driver
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Date: Mon, 17 Oct 2011 13:06:59 -0400
In-Reply-To: <20111017170218.GH2971@phenom.ffwll.local>
References: <1318788068.12224.125.camel@gandalf.stny.rr.com>
	 <20111017085546.GB2971@phenom.ffwll.local>
	 <1318851627.12224.135.camel@gandalf.stny.rr.com>
	 <20111017170218.GH2971@phenom.ffwll.local>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 19:02 +0200, Daniel Vetter wrote:

> Thanks. Your userspace is issueing MI_WAIT_SCANLINES cmds to the gpu,
> which just doesn't work. Can you please upgrade xf86-video-intel to the
> latest released version and check whether it works.
> 
> Generally userspace with that bug is extremely old (and if the other
> things are equally outdated) rather buggy for Sandybridge. I highly
> suggest updating the entire graphics stack to something modern
> (Sandybridge-wise).

Thanks for the quick response.

OK, I'll wait till after KS to do more on my wife's box. It is currently
useable, and I hate to make it worse and leave her computer in a broken
state ;)


It's running Fedora 14, and I rather avoid Gnome3 and systemd, which
prevents me from moving her to Fedora 15. If F14 does not provide the
necessary updates, I'll move her over to a Debian system.

Thanks!

-- Steve


