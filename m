Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab1HZWW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 18:22:26 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:36827 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751213Ab1HZWWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 18:22:25 -0400
Subject: Re: [PATCH 0/4] dynamic debug: cleanups + compile fix
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: Jason Baron <jbaron@redhat.com>, Greg KH <greg@kroah.com>,
        jim.cromie@gmail.com, bvanassche@acm.org, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110826221845.GA18858@suse.de>
References: <cover.1314291909.git.jbaron@redhat.com>
	 <20110826182900.GA30226@kroah.com> <20110826184742.GA2469@redhat.com>
	 <20110826190417.GA30356@suse.de> <1314396881.9624.8.camel@Joe-Laptop>
	 <20110826221845.GA18858@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Aug 2011 15:22:23 -0700
Message-ID: <1314397343.9624.9.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 15:18 -0700, Greg KH wrote:
> On Fri, Aug 26, 2011 at 03:14:41PM -0700, Joe Perches wrote:
> > On Fri, 2011-08-26 at 12:04 -0700, Greg KH wrote:
> > > > > Care to redo this based on the comments received so far?
> > > > I re-posted 3/4 based on the comments already. The comment on patch #1
> > > > regarding adding macro parenthesis, I don't believe makes any functional
> > > > change...do you still need a re-post the series?
> > #define true 1
> > gains nothing from parenthesis either.
> I don't think that is the case here, right?

Nope.

It is the case, the parentheses are not necessary.

