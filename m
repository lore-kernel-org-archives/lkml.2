Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab0IPUHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:07:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55443
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754164Ab0IPUHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:07:51 -0400
Date: Thu, 16 Sep 2010 13:08:09 -0700 (PDT)
Message-Id: <20100916.130809.176654647.davem@davemloft.net>
To: samuel@sortiz.org
Cc: arnd@arndb.de, codalist@TELEMANN.coda.cs.cmu.edu, autofs@linux.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        hch@infradead.org, mikulas@artax.karlin.mff.cuni.cz,
        Trond.Myklebust@netapp.com, vandrove@vc.cvut.cz, al@alarsen.net,
        jack@suse.cz, dushistov@mail.ru, mingo@elte.hu, netdev@vger.kernel.org,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, andrew.hendry@gmail.com
Subject: Re: Remaining BKL users, what to do
From: David Miller <davem@davemloft.net>
In-Reply-To: <1284656277.2962.0.camel@sortiz-mobl>
References: <201009161632.59210.arnd@arndb.de>
	<1284656277.2962.0.camel@sortiz-mobl>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <samuel@sortiz.org>
Date: Thu, 16 Sep 2010 18:57:56 +0200

> On Thu, 2010-09-16 at 16:32 +0200, Arnd Bergmann wrote:
>> net/appletalk:
>> net/ipx/af_ipx.c:
>> net/irda/af_irda.c:
>> 	Can probably be saved from retirement in drivers/staging if the
>> 	maintainers still care.
> I'll take care of the IrDA part.

Thanks a lot Sam.
