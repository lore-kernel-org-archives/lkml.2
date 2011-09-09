Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1IIPTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 11:19:44 -0400
Received: from ra.se.axis.com ([195.60.68.13]:59628 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab1IIPTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 11:19:43 -0400
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Sep 2011 11:19:43 EDT
Date: Fri, 9 Sep 2011 17:10:31 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, Mikael Starvik <starvik@axis.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Torben Hohn <torbenh@gmx.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH 07/62] cris: irq: Remove IRQF_DISABLED
Message-ID: <20110909151031.GV28502@axis.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com> <1315383059-3673-8-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315383059-3673-8-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 10:10:04AM +0200, Yong Zhang wrote:
> This flag is a NOOP and can be removed now.

For the CRIS parts:

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
