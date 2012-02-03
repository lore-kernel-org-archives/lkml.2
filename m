Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab2BCIzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 03:55:24 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57056 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab2BCIzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 03:55:23 -0500
X-Originating-IP: 217.70.178.132
X-Originating-IP: 50.43.15.19
Date: Fri, 3 Feb 2012 00:55:16 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across lines
Message-ID: <20120203085516.GF3008@leaf>
References: <20120203052727.GA15035@leaf>
 <1328247515.18641.84.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328247515.18641.84.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 09:38:35PM -0800, Joe Perches wrote:
> On Thu, 2012-02-02 at 21:27 -0800, Josh Triplett wrote:
> > checkpatch already makes an exception to the 80-column rule for quoted
> > strings, and Documentation/CodingStyle recommends not splitting quoted
> > strings across lines, because it breaks the ability to grep for the
> > string.  Rather than just permitting this, actively warn about quoted
> > strings split across lines.
> []
> > +			WARN("SPLIT_STRING",
> > +			     "quoted string split across lines\n" . $herecurr);
> 
> I think the output would be better as:
> 
> 			WARN("SPLIT_STRING",
> 			     "quoted string split across lines\n" . $hereprev);

Awesome; I'd thought that it would look better to show the previous
line, but I didn't know about $hereprev.  PATCHv3 momentarily.

- Josh Triplett
