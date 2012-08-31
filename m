Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab2HaPmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 11:42:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35783 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753966Ab2HaPmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 11:42:17 -0400
Message-ID: <1346427736.31659.13.camel@joe2Laptop>
Subject: Re: [PATCH 2/4] scripts/checkincludes.pl: Simplify and shorten
 argument logic
From: Joe Perches <joe@perches.com>
To: Cruz Julian Bishop <cruzjbishop@gmail.com>
Cc: mcgrof@gmail.com, linux-kernel@vger.kernel.org
Date: Fri, 31 Aug 2012 08:42:16 -0700
In-Reply-To: <1346419090-3808-3-git-send-email-cruzjbishop@gmail.com>
References: <1346419090-3808-1-git-send-email-cruzjbishop@gmail.com>
	 <1346419090-3808-3-git-send-email-cruzjbishop@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-31 at 23:18 +1000, Cruz Julian Bishop wrote:
> This patch allows for much easier implementation of arguments
> when modifying checkincludes.pl
> 
> The variable $file is also initially named $arg - I wasn't sure
> if memory would be a problem (I know it would be in Java/C#) if
> another $file variable was initialized with the value of $arg,
> so I just left it.
> 
> Overall, this still works nicely. There are some more
> potential simplifications, but I will cover those in another
> patch if I decide to implement them tonight.

perl argument processing is normally done via Getopt::Long.

http://perldoc.perl.org/Getopt/Long.html

