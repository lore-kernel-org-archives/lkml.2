Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1FTLRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 07:17:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41361 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1FTLRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 07:17:07 -0400
Date: Mon, 20 Jun 2011 12:16:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        linux-arm-kernel@lists.infradead.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: Re: [PATCH][Trivial] S3C2410 bluetooth: Remove duplicate
	linux/leds.h include
Message-ID: <20110620111629.GC26089@n2100.arm.linux.org.uk>
References: <alpine.LNX.2.00.1106201035590.18991@swampdragon.chaosbits.net> <4DFF1AA5.80508@ru.mvista.com> <alpine.LNX.2.00.1106201232530.18991@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106201232530.18991@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 12:34:37PM +0200, Jesper Juhl wrote:
> On Mon, 20 Jun 2011, Sergei Shtylyov wrote:
> 
> > Hello.
> > 
> > On 20-06-2011 12:40, Jesper Juhl wrote:
> > 
> > > Remove the duplicate inclusion of linux/leds.h from
> > > arch/arm/mach-s3c2410/h1940-bluetooth.c that was added by commit 50e2d10d.
> > 
> >    Pelase also specify that commit's summary in parens.
> > 
> 
> Anyone can just do a "git show 50e2d10d" to read it. But sure, here's a 
> new patch description:

Anyone with git can.  Those without git can't (eg, because they're using
some other tool for source management.)  This is why Linus requires commit
IDs to be followed by their summary.

Please ensure that you always include the summary along with the git commit
id.
