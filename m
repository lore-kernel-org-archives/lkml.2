Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab2BCGer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 01:34:47 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34313 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2BCGeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 01:34:46 -0500
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.15.19
Date: Thu, 2 Feb 2012 22:34:36 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across lines
Message-ID: <20120203063435.GA15436@leaf>
References: <20120203052727.GA15035@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203052727.GA15035@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 09:27:27PM -0800, Josh Triplett wrote:
> checkpatch already makes an exception to the 80-column rule for quoted
> strings, and Documentation/CodingStyle recommends not splitting quoted
> strings across lines, because it breaks the ability to grep for the
> string.  Rather than just permitting this, actively warn about quoted
> strings split across lines.
[...]
> v2: Add the "after open parenthesis" heuristic which almost completely
> eliminates non-user-visible strings, leaving only 12 in the entire
> kernel, versus thousands of correct matches.  Change "breaks
> greppability" to "breaks the ability to grep for the string".

Sorry, forgot to change "PATCH" to "PATCHv2" in the subject.

- Josh Triplett
