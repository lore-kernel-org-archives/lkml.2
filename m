Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2DOMrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 08:47:17 -0400
Received: from smtp1.su.se ([130.237.162.112]:46395 "EHLO smtp.su.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752549Ab2DOMrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 08:47:15 -0400
X-Spam-Flag: NO
X-Spam-Score: -4
Message-ID: <4F8AC34F.1050702@debian.org>
Date: Sun, 15 Apr 2012 14:47:11 +0200
From: Per Olofsson <pelle@debian.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Bojan Smojver <bojan@rexursive.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for hibernate/thaw
 buffering
References: <1334267969.2573.14.camel@shrek.rexursive.com>
In-Reply-To: <1334267969.2573.14.camel@shrek.rexursive.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-04-12 23:59, Bojan Smojver skrev:
> Hi Rafael,
> 
> Yes, I know - it is getting a bit ridiculous. Such a simple problem, so
> many patches. Anyhow...
> 
> Here we also fix the calculation of pages for read buffering. Not really
> very significant, but may become important in some really tight memory
> scenarios. And after thinking more about low_free_pages() inline
> function, Per was right - it is better to call an already existing
> function, rather than roll our own. Keeps kernel smaller and there is no
> significant performance gain otherwise.
> 
> Per,
> 
> Feel free to reply with your signed-off.

Signed-off-by: Per Olofsson <pelle@debian.org>

-- 
Pelle
