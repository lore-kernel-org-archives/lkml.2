Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab2BCFil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 00:38:41 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39714 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750830Ab2BCFik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 00:38:40 -0500
Message-ID: <1328247515.18641.84.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across lines
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nick Bowler <nbowler@elliptictech.com>
Date: Thu, 02 Feb 2012 21:38:35 -0800
In-Reply-To: <20120203052727.GA15035@leaf>
References: <20120203052727.GA15035@leaf>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-02 at 21:27 -0800, Josh Triplett wrote:
> checkpatch already makes an exception to the 80-column rule for quoted
> strings, and Documentation/CodingStyle recommends not splitting quoted
> strings across lines, because it breaks the ability to grep for the
> string.  Rather than just permitting this, actively warn about quoted
> strings split across lines.
[]
> +			WARN("SPLIT_STRING",
> +			     "quoted string split across lines\n" . $herecurr);

I think the output would be better as:

			WARN("SPLIT_STRING",
			     "quoted string split across lines\n" . $hereprev);


