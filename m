Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1E1KXJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 06:23:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:46296 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab1E1KXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 06:23:08 -0400
Subject: Re: perf: regression with PERF_EVENT_IOC_REFRESH
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        acme@redhat.com
In-Reply-To: <alpine.DEB.2.00.1105272332400.9313@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>
	 <1306182141.2497.5.camel@laptop>
	 <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>
	 <1306233036.2497.15.camel@laptop>
	 <alpine.DEB.2.00.1105272332400.9313@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 28 May 2011 12:22:24 +0200
Message-ID: <1306578144.1200.1150.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 23:38 -0400, Vince Weaver wrote:
> on that note (and while trying to document exactly what the ioctls do) it 
> seems that a PERF_EVENT_IOC_REFRESH with an argument of anything higher 
> than one does not work on kernels 2.6.36 and newer.  The behavior acts
> as if 1 was passed, even if you pass in, say, 3.

Urgh, no that should definitely work. Thanks for the test-case, I'll
work on that (probably not until Monday though, but who knows).
