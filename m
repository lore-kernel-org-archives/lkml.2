Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1KBRqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:46:30 -0400
Received: from trinity.fluff.org ([89.16.178.74]:42167 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755795Ab1KBRq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:46:28 -0400
Date: Wed, 2 Nov 2011 17:46:25 +0000
From: Ben Dooks <ben@trinity.fluff.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ben Dooks <ben-linux@fluff.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the bjdooks-i2c tree with Linus'
	tree
Message-ID: <20111102174625.GI18361@trinity.fluff.org>
References: <20111102122221.9040e7a07bb0e3e2c46a5188@canb.auug.org.au> <20111102022850.GA5875@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102022850.GA5875@zhy>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 10:28:50AM +0800, Yong Zhang wrote:
> On Wed, Nov 02, 2011 at 12:22:21PM +1100, Stephen Rothwell wrote:
> > Hi Ben,
> > 
> > Today's linux-next merge of the bjdooks-i2c tree got a conflict in
> > drivers/i2c/busses/i2c-designware-platdrv.c between commit 4311051c358a
> > ("i2c: irq: Remove IRQF_DISABLED") from Linus' tree and commit
> > f8420b7bf6ce ("fixup merge") from the bjdooks-i2c tree.
> > 
> > I fixed it up (by removing the IRQF_DISABLED flag) but this change should
> > probably be sent to Linus as it appears to have been fixed up incorrectly
> > there.
> 
> Yeah, we should remove that flag. And that is what commit 4311051c358a
> want to achieve.

Unfortunately there was a merge conflict. I thought it got fixed, but
seems not. I will sort out fixing it later.
 
-- 
Large Hadron Colada: A large Pina Colada that makes the universe disappear.

