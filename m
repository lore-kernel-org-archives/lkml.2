Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab1LIAqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:46:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63726 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1LIAqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:46:36 -0500
X-Authority-Analysis: v=2.0 cv=QrfcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=bix7J2-88xUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=Bb7kA678-z8URiFYjO0A:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 2/2] trace_event_filter: factorize filter creation
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20111208233206.GC12108@google.com>
References: <20111123014603.GA19630@google.com>
	 <20111123020016.GB19630@google.com> <20111128204932.GK18864@google.com>
	 <1322518512.17003.34.camel@frodo>  <20111208233206.GC12108@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 19:46:34 -0500
Message-ID: <1323391594.30977.159.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 15:32 -0800, Tejun Heo wrote:
> On Mon, Nov 28, 2011 at 05:15:12PM -0500, Steven Rostedt wrote:
> > On Mon, 2011-11-28 at 12:49 -0800, Tejun Heo wrote:
> > > [OFFLIST]
> > > 
> > > Ping.
> > > 
> > 
> > Thanks! I actually remembered, just a bit slow today :)
> 
> Did you get around to it?

This has some major conflicts with what is currently in tip/perf/core.
Could you rebase against it?

Note, 49aa29513ec995f201664cf6eee36e5326ed38bf does change how the
filter is displayed for system filters.

-- Steve


