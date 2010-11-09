Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0KIRWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:22:46 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43804 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab0KIRWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:22:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Z+vvXS/lmA2WL34AVhWRxMANkfvPuhtHvTEAX+4AnIBPBa5hfxjtFQTbwdjBUwYq4M
         ibgV18TzUCFOlSt8xHqQR1b4n4M6poP+Tq8MjA9nV1DlAHXIlLZkmyTH4vhT6XeaORWa
         EzcByPZEcsxuguTutxv00XD2vAu8iCm/zEwWQ=
Date: Tue, 9 Nov 2010 19:23:14 +0200
From: Jarkko Nikula <jhnikula@gmail.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] ASoC: Fix compile error if CONFIG_DEBUG_FS is not
 configured
Message-Id: <20101109192314.31c6ef2f.jhnikula@gmail.com>
In-Reply-To: <1289296866.3290.4.camel@odin>
References: <1289293604.28671.5.camel@mola>
	<1289296866.3290.4.camel@odin>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Nov 2010 10:01:06 +0000
Liam Girdwood <lrg@slimlogic.co.uk> wrote:

> On Tue, 2010-11-09 at 17:06 +0800, Axel Lin wrote:
> > Add soc_init_card_debugfs and soc_cleanup_card_debugfs functions to fix below error.
> > 
> >   CC      sound/soc/soc-core.o
> > sound/soc/soc-core.c: In function 'soc_probe':
> > sound/soc/soc-core.c:1689: error: implicit declaration of function 'soc_init_card_debugfs'
> > sound/soc/soc-core.c: In function 'soc_remove':
> > sound/soc/soc-core.c:1718: error: implicit declaration of function 'soc_cleanup_card_debugfs'
> > make[2]: *** [sound/soc/soc-core.o] Error 1
> > make[1]: *** [sound/soc] Error 2
> > make: *** [sound] Error 2
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
> -- 
Oops...

Acked-by: Jarkko Nikula <jhnikula@gmail.com>
