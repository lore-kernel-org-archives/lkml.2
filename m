Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1H3MNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 08:13:08 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:52246 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1H3MNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 08:13:06 -0400
X-Greylist: delayed 1173 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Aug 2011 08:13:06 EDT
Subject: Re: [Bug #41102] BUG dentry: Poison overwritten / BUG buffer_head:
 Poison overwritten
From: Paul Bolle <pebolle@tiscali.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
In-Reply-To: <gUVi6eNP8RE.A.yOG.depWOB@chimera>
References: <Sm7qbRR0zn.A.yAG.LepWOB@chimera>
	 <gUVi6eNP8RE.A.yOG.depWOB@chimera>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 14:13:00 +0200
Message-ID: <1314706380.1989.8.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-08-28 at 21:01 +0200, Rafael J. Wysocki wrote:
> Please verify if it still should
> be listed and let the tracking team know (either way).

>From comment #2:
> [...] please note that the 3.0.1 kernel I
> triggered this issue with seems to be the first I ran on this machine that has
> CONFIG_SLUB_DEBUG_ON set. So on this machine this issue - if it's more than a
> one time goof - would never have showed up in the logs unless I manually booted
> with "slub_debug" on the command line. And I can't remember booting with
> "slub_debug".

At this moment I see little reason to track this bug entry as a
regression.


Paul Bolle

