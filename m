Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab2DVUfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 16:35:41 -0400
Received: from smtp3.su.se ([130.237.164.77]:55093 "EHLO smtp.su.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752261Ab2DVUfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 16:35:23 -0400
X-Spam-Flag: NO
X-Spam-Score: -4
Message-ID: <4F946B86.4000509@debian.org>
Date: Sun, 22 Apr 2012 22:35:18 +0200
From: Per Olofsson <pelle@debian.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bojan Smojver <bojan@rexursive.com>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for hibernate/thaw
 buffering
References: <1334267969.2573.14.camel@shrek.rexursive.com> <201204221347.52883.rjw@sisk.pl> <22aaaccf-5898-460c-b1e4-a87c153d9e0c@email.android.com> <201204222229.47160.rjw@sisk.pl>
In-Reply-To: <201204222229.47160.rjw@sisk.pl>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-04-22 22:29, Rafael J. Wysocki skrev:
> Well, it was late for the 3.4 merge window and it wasn't clear whether or
> not the patch was a regression fix at that time.  It is not very
> straightforward and in my opinion it should be tested a bit wider before it
> goes into -stable.

Hopefully it will soon get applied in Debian unstable and then get much
more testing.

It is also possible to create a much smaller patch which only subtracts
the high pages and nothing else.

-- 
Pelle
