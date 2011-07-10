Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1GJLVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:21:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab1GJLV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:21:28 -0400
Date: Sun, 10 Jul 2011 07:22:58 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "" <farbing@web.de>
Subject: Re: [Bug #38972] Kernel panic when syncing while cifs is mounted
Message-ID: <20110710072258.1ffbd52c@corrin.poochiereds.net>
In-Reply-To: <XNkIyhV6dgF.A.BVG.xBYGOB@chimera>
References: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera>
	<XNkIyhV6dgF.A.BVG.xBYGOB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jul 2011 12:38:24 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.39.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38972
> Subject		: Kernel panic when syncing while cifs is mounted
> Submitter	:  <farbing@web.de>
> Date		: 2011-07-08 15:39 (3 days old)
> First-Bad-Commit: http://git.kernel.org/linus/dd8544661947ad6d8d87b3c9d4333bfa1583d1bc
> Handled-By	: Jeff Layton <jlayton@redhat.com>
> Patch		: https://bugzilla.kernel.org/attachment.cgi?id=65082
> 
> 

The patch is now in Steve French's tree. Just waiting on him to push it
and some other fixes to Linus, hopefully before 3.0 ships.

-- 
Jeff Layton <jlayton@redhat.com>
