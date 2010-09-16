Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab0IPQ5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 12:57:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36163 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab0IPQ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 12:57:43 -0400
Subject: Re: Remaining BKL users, what to do
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: codalist@TELEMANN.coda.cs.cmu.edu, autofs@linux.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Christoph Hellwig <hch@infradead.org>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Petr Vandrovec <vandrove@vc.cvut.cz>, Anders Larsen <al@alarsen.net>,
        Jan Kara <jack@suse.cz>, Evgeniy Dushistov <dushistov@mail.ru>,
        Ingo Molnar <mingo@elte.hu>, netdev@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Hendry <andrew.hendry@gmail.com>
In-Reply-To: <201009161632.59210.arnd@arndb.de>
References: <201009161632.59210.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 18:57:56 +0200
Message-ID: <1284656277.2962.0.camel@sortiz-mobl>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 16:32 +0200, Arnd Bergmann wrote:
> net/appletalk:
> net/ipx/af_ipx.c:
> net/irda/af_irda.c:
> 	Can probably be saved from retirement in drivers/staging if the
> 	maintainers still care.
I'll take care of the IrDA part.

Cheers,
Samuel.


