Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927Ab0HLXje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 19:39:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26846 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab0HLXjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 19:39:33 -0400
Date: Thu, 12 Aug 2010 16:38:37 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Cloning arch-independant KConfig
Message-ID: <20100812233837.GG22777@mail.oracle.com>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,
	I guess this is either a feature request or just wondering
whether KConfig supports this idea.
	Often I have a wonderful minimal .config that builds a test
kernel.  It only compiles the things I want in my kernel and modules,
nothing more.  Usually I start from a distro kernel and then keep
turning things off until I reach some minimum.
	However, when I get a new machine of a different architecture, I
can't bring that work forward.  If I take this .config to that arch, the
oldconfig just breaks.  I don't get good defaults for the arch-specific
stuff.  Conversely, if I start from a distro .config for the new arch, I
have to repeat all the whittle-down work.
	Is there any way to "extract" the non-arch-specific config
values?  Essentially, all the "use USB, build ext3, give me these
network cards" fields should be kept, but I want to start from a default
architecture config.

Joel

-- 

"Friends may come and go, but enemies accumulate." 
        - Thomas Jones

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
