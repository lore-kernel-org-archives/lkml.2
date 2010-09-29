Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab0I2R36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 13:29:58 -0400
Received: from leb.cs.unibo.it ([130.136.1.102]:34539 "EHLO leb.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab0I2R35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 13:29:57 -0400
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Sep 2010 13:29:57 EDT
Date: Wed, 29 Sep 2010 19:19:45 +0200
From: Renzo Davoli <renzo@cs.unibo.it>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Miller <davem@davemloft.net>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, julia@diku.dk, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, shemminger@vyatta.com,
        shammash@artha.org
Subject: Re: [uml-devel] {painfully BISECTED} Please revert f25c80a4b2:
	arch/um/drivers: remove duplicate structure field initialization
Message-ID: <20100929171944.GA3942@cs.unibo.it>
References: <AANLkTim85sH_2o=xCiDuoQrHq_7ZL96Y91xQMGxUP5Fy@mail.gmail.com> <20100928211106.GE19804@ZenIV.linux.org.uk> <20100928212417.GF19804@ZenIV.linux.org.uk> <20100928.144215.246551852.davem@davemloft.net> <20100928215108.GH19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100928215108.GH19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh, joy...  I'm regulary using uml, with some of these drivers used
> from time to time, but I've no fscking clue on e.g. VDE - even on
> the "what the hell it is" level ;-/
VDE is Virtual Distributed Ethernet.
http://wiki.virtualsquare.org/wiki/index.php/Introduction#Virtual_Square_Networking

I am the main author of VDE.
Was it just an example or there is a bug on the VDE support for user-mode Linux?

	renzo
