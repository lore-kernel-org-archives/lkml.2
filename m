Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0H3A4J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 20:56:09 -0400
Received: from smtp-out-108.synserver.de ([212.40.180.108]:1131 "HELO
	smtp-out-104.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753588Ab0H3A4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 20:56:07 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 534
Date: Mon, 30 Aug 2010 02:56:04 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16393] kernel BUG at fs/block_dev.c:765!
Message-ID: <20100830005604.GA1573@arch.trippelsdorf.de>
References: <c1_O4wHrlB.A.63.mbueMB@chimera>
 <ByD_7B96czP.A.u4C.yeueMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ByD_7B96czP.A.u4C.yeueMB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 01:13:29AM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16393
> Subject		: kernel BUG at fs/block_dev.c:765!
> Submitter	: Markus Trippelsdorf <markus@trippelsdorf.de>
> Date		: 2010-07-14 13:52 (47 days old)
> Message-ID	: <20100714135217.GA1797@arch.tripp.de>
> References	: http://marc.info/?l=linux-kernel&m=127911564213748&w=2
> 

This bug is already fixed by:
e75aa85892b2ee78c79edac720868cbef16e62eb

Please close this entry.
Thanks.

-- 
»A man who doesn't know he is in prison can never escape.«
William S. Burroughs
