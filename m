Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1AGU1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:27:12 -0500
Received: from canuck.infradead.org ([134.117.69.58]:36447 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab1AGU1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:27:10 -0500
Subject: Re: sparc boot failure due to perf init
From: Peter Zijlstra <peterz@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, lkml <linux-kernel@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>
In-Reply-To: <1294431832.2016.457.camel@laptop>
References: <20110107201805.GA28104@merkur.ravnborg.org>
	 <1294431832.2016.457.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 07 Jan 2011 21:27:35 +0100
Message-ID: <1294432055.2016.458.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 21:23 +0100, Peter Zijlstra wrote:
> On Fri, 2011-01-07 at 21:18 +0100, Sam Ravnborg wrote:
> > This was introduced by: 
> > "perf, arch: Cleanup perf-pmu init vs lockup-detector" - 004417a6d468e24399e383645c068b498eed84ad
> > 
> > I did not see any obvious fix.
> > (To avoid it is simple - I can disable it in my config).
> 
> Or you can switch back to arch_initcall() for now, it'll cause the
> generic watchdog stuff not to work, but that's a lot less important.
> 
> I'll have a chat with Dave on how to best sort all this.

That is, simply revert the sparc bit for now.
