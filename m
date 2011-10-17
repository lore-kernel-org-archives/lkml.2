Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab1JQSTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:19:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48738 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1JQSTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:19:24 -0400
X-Authority-Analysis: v=1.1 cv=G2mrdTwFgeQf4gnIVCGl5REDSA/JVLCrZmxI9r5hHjY= c=1 sm=0 a=oe0lC-8eqlkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=1Ha2rNStYJevgBaX_WYA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1318875562.4722.4.camel@gandalf.stny.rr.com>
Subject: Re: Problems with videos and i915 driver
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Date: Mon, 17 Oct 2011 14:19:22 -0400
In-Reply-To: <20111017175258.GJ2971@phenom.ffwll.local>
References: <1318788068.12224.125.camel@gandalf.stny.rr.com>
	 <20111017085546.GB2971@phenom.ffwll.local>
	 <1318851627.12224.135.camel@gandalf.stny.rr.com>
	 <20111017170218.GH2971@phenom.ffwll.local>
	 <1318871219.12224.138.camel@gandalf.stny.rr.com>
	 <20111017175258.GJ2971@phenom.ffwll.local>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 19:52 +0200, Daniel Vetter wrote:
> On Mon, Oct 17, 2011 at 01:06:59PM -0400, Steven Rostedt wrote:
> > It's running Fedora 14, and I rather avoid Gnome3 and systemd, which
> > prevents me from moving her to Fedora 15. If F14 does not provide the
> > necessary updates, I'll move her over to a Debian system.
> 
> Generally we're (unfortunately) only now cracking down on a few
> long-standing Sandybdrige gpu hang issues, so you want something that
> tracks upstream (and sometimes even git master) pretty closely.
> 

What git tree is this? I could try it out.

-- Steve


