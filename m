Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab0HAOtd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 10:49:33 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59536 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab0HAOtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 10:49:31 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C558945.3030501@s5r6.in-berlin.de>
Date: Sun, 01 Aug 2010 16:48:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Paul Rolland <rol@as2917.net>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        DRI <dri-devel@lists.freedesktop.org>
Subject: Re: 2.6.35-rc6-git6: Reported regressions from 2.6.34
References: <2dWFdr9kTFM.A.P0D.spXVMB@chimera>
In-Reply-To: <2dWFdr9kTFM.A.P0D.spXVMB@chimera>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> If you know of any other unresolved regressions from 2.6.34, please let us
> know either and we'll add them to the list.

Subject		: 2.6.35-rc6+: i915: Bisected regression
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: Sun, 1 Aug 2010 11:01:00 +0200
Message-ID	: <201008011101.01429.thomas@m3y3r.de>
References	: http://lkml.org/lkml/2010/8/1/43
First-Bad-Commit:
http://git.kernel.org/linus/d1b851fc0d105caa6b6e3e7c92d2987dfb52cbe0

-- 
Stefan Richter
-=====-==-=- =--- ----=
http://arcgraph.de/sr/
