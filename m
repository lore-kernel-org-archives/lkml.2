Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0IBN5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 09:57:55 -0400
Received: from gw1.transmode.se ([213.115.205.20]:47241 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340Ab0IBN5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 09:57:54 -0400
In-Reply-To: <1283425149.3085.6.camel@brekeke>
References: <1283357021-16187-1-git-send-email-w.sang@pengutronix.de>	 <1283366151.2209.21.camel@brekeke>
	 <OF213EDC22.80E0A084-ONC1257792.0025CB36-C1257792.00268F36@transmode.se> <1283425149.3085.6.camel@brekeke>
Subject: Re: [RFC] jffs2: use cond_resched() instead of yield()
X-KeepSent: 13870AE6:AC42397E-C1257792:004C0931;
 type=4; name=$KeepSent
To: dedekind1@gmail.com
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Ingo Molnar <mingo@elte.hu>, Wolfram Sang <w.sang@pengutronix.de>
X-Mailer: Lotus Notes Release 8.5.2 August 10, 2010
Message-ID: <OF13870AE6.AC42397E-ONC1257792.004C0931-C1257792.004C4099@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Thu, 2 Sep 2010 15:52:52 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.1FP3|May 23, 2010) at
 2010-09-02 15:57:53
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <dedekind1@gmail.com> wrote on 2010/09/02 12:59:09:
>
> On Thu, 2010-09-02 at 09:01 +0200, Joakim Tjernlund wrote:
> > At the time cond_resched() was a problem but now I don't know. The erasing
> > has moved to the GC thread and been somewhat reworked. I don't know if
> > it still needs yield(). Perhaps David can tell?
>
> I think 'yield()' is rather a hack than a real solution.

Yes, the real fix is to move erasing to GC and that has been done now.
There is a good chance yield() can be removed without regression
but I am not sure nor do I have the time to test that.

 Jocke

