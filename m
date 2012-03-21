Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab2CUBYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 21:24:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41027 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755416Ab2CUBYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 21:24:19 -0400
Message-ID: <1332293056.27711.12.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across lines
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 20 Mar 2012 18:24:16 -0700
In-Reply-To: <20120320210644.GA2493@leaf>
References: <20120320210644.GA2493@leaf>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 14:06 -0700, Josh Triplett wrote:
> checkpatch already makes an exception to the 80-column rule for quoted
> strings, and Documentation/CodingStyle recommends not splitting quoted
> strings across lines, because it breaks the ability to grep for the
> string.  Rather than just permitting this, actively warn about quoted
> strings split across lines.

Hi Josh.

I don't recall seeing your patch before, but I submitted
a similar one that I believe Andrew has in his tree.

https://lkml.org/lkml/2012/3/2/24

