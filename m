Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0HRWR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 18:17:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0HRWR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 18:17:27 -0400
Date: Wed, 18 Aug 2010 18:17:22 -0400
From: Dave Jones <davej@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: apw@canonical.com, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: add memset checks to checkpatch.pl
Message-ID: <20100818221721.GA2667@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Joe Perches <joe@perches.com>, apw@canonical.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20100818204016.GA29640@redhat.com>
 <1282167133.6724.165.camel@Joe-Laptop>
 <20100818214818.GA31094@redhat.com>
 <1282168679.6724.174.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282168679.6724.174.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 02:57:59PM -0700, Joe Perches wrote:
 > > I'm all for improving my shoddy perl where possible, but this doesn't seem to actually
 > > catch any of the test cases I wrote.  (it's also missing a } )
 > 
 > I intend never to be a perl monk.
 > 
 > I notice the missing { before the elsif after I sent it.
 > Oh well.
 > 
 > I just typed it in the emailer, so it's not tested at all.
 > Also it's missing a $ after 1 in the second $memset_size test.

still didn't catch anything for me.

 > What are your test cases anyway?

memset(foo, 0, 10);
memset(foo, 10, 0);
memset(foo, 1, 10);
memset(foo, 10, 1);

 > Likely $Lval isn't matching things like
 > sizeof(*foo) so this isn't checked:
 > 
 > 	memset(foo, bar, sizeof(*foo));

I chose to just ignore any non integer arguments to keep things simple.

	Dave

