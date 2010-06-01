Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab0FAGEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 02:04:43 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:54397 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0FAGEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 02:04:41 -0400
Date: Tue, 1 Jun 2010 08:04:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH -mmotm] media: ak881x needs slab.h
Message-ID: <20100601060433.GA24396@elte.hu>
References: <201005192341.o4JNf5Hv012931@imap1.linux-foundation.org>
 <20100520140823.a9b81de9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520140823.a9b81de9.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add slab.h to fix ak881x build:
> 
> drivers/media/video/ak881x.c:265:error: implicit declaration of function 'kzalloc'
> drivers/media/video/ak881x.c:265:warning: assignment makes pointer from integer without a cast
> drivers/media/video/ak881x.c:283:error: implicit declaration of function 'kfree'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> ---
>  drivers/media/video/ak881x.c |    1 +

This build bug is now triggering in .35-rc1 as well.

	Ingo
