Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab1KBC3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:29:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58213 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab1KBC3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:29:04 -0400
Date: Wed, 2 Nov 2011 10:28:50 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the bjdooks-i2c tree with Linus' tree
Message-ID: <20111102022850.GA5875@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20111102122221.9040e7a07bb0e3e2c46a5188@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111102122221.9040e7a07bb0e3e2c46a5188@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 12:22:21PM +1100, Stephen Rothwell wrote:
> Hi Ben,
> 
> Today's linux-next merge of the bjdooks-i2c tree got a conflict in
> drivers/i2c/busses/i2c-designware-platdrv.c between commit 4311051c358a
> ("i2c: irq: Remove IRQF_DISABLED") from Linus' tree and commit
> f8420b7bf6ce ("fixup merge") from the bjdooks-i2c tree.
> 
> I fixed it up (by removing the IRQF_DISABLED flag) but this change should
> probably be sent to Linus as it appears to have been fixed up incorrectly
> there.

Yeah, we should remove that flag. And that is what commit 4311051c358a
want to achieve.

Thanks,
Yong

