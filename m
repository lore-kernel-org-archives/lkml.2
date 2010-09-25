Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab0IYRe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 13:34:56 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:10928 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab0IYRez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 13:34:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19614.12985.649827.886053@pilspetsen.it.uu.se>
Date: Sat, 25 Sep 2010 19:34:49 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Miller <davem@davemloft.net>
Cc: mikpe@it.uu.se, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.36-rc regression] occasional complete system hangs on
 sparc64 SMP
In-Reply-To: <20100923.120935.173861259.davem@davemloft.net>
References: <19611.34846.813757.309183@pilspetsen.it.uu.se>
	<20100923.120935.173861259.davem@davemloft.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:
 > From: Mikael Pettersson <mikpe@it.uu.se>
 > Date: Thu, 23 Sep 2010 19:02:22 +0200
 > 
 > > The 2.6.36-rc kernels do appear to be solid on a UP Ultra5, but that
 > > one no longer does any gcc builds or tests, only kernel builds.
 > > 
 > > Any ideas, or do I have to try to bisect this?
 > 
 > I've seen this too, it's some kind of deadlock obviously.
 > 
 > Unfortunately I haven't gotten any further than you have in the
 > analysis.

Update: I got another hang with 2.6.36-rc5, then went back to
2.6.36-rc1 which hung twice.  SYSRQ would print help text and
the name of the command but not print anything useful on the
console.  Now trying some of the 2.6.35-git snapshots before -rc1.
