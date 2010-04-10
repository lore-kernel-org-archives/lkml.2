Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab0DJUEg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 16:04:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:55325 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab0DJUEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 16:04:35 -0400
Date: Sat, 10 Apr 2010 22:04:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: maciej.rutecki@gmail.com, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc3 doesn't suspend to disk (-rc2 did)
In-Reply-To: <4BC03B16.6000403@gmail.com>
Message-ID: <alpine.LNX.2.00.1004102200510.8345@pobox.suse.cz>
References: <alpine.LNX.2.00.1004020215100.8345@pobox.suse.cz> <201004082044.26949.maciej.rutecki@gmail.com> <4BC03A11.4050407@gmail.com> <4BC03B16.6000403@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Apr 2010, Jiri Slaby wrote:

> > Jiri, could you add there whether you changed config options somehow?
> > The bug drives me crazy.
> 
> (and check whether the fix there solves your problem or we hit different
> issues)

Yes, I can confirm that the patch fixes the issue I have been seeing as 
well (I have been testing with different DEBUG_BLOCK_EXT_DEVT setting with 
-rc2 and -rc3).

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
