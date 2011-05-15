Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089Ab1EOPve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 11:51:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52271 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760052Ab1EOPvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 11:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:cc:subject:x-mailer:references:in-reply-to
         :content-type:content-id:date:message-id:mime-version
         :content-transfer-encoding;
        b=OW+KmwF9ThCyysos76caLej9gJcsOjL8oAB0TFeHsJxGIG4FGJ3pWZoAS4MQUEPEpd
         tHXricj/ya57sIx2FtWaZOMroBDQEiGoB00vmmdhRfjCwTXABDm1yAaMmj/qTpFx1pgg
         ltX97cHIPSv1peZe1TwdNyLQTUJSn3bX2uWqI=
From: Marek Vasut <marek.vasut.n900@gmail.com>
Reply-To: Marek Vasut <marek.vasut.n900@gmail.com>
To: Cyril Hrubis <metan@ucw.cz>, Marek Vasut <marek.vasut@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Subject: Re: Zaurus CF tests -- ok
X-Mailer: Modest 3.2
References: <20110415211822.GB21111@atrey.karlin.mff.cuni.cz>
	 <20110415213817.GC4420@atrey.karlin.mff.cuni.cz>
	 <20110416074134.GA26440@ucw.cz> <201105151426.50230.marek.vasut@gmail.com>
	  <20110515143141.GA7913@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20110515143141.GA7913@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=utf-8
Content-ID: <1305474684.17656.1.camel@konomi>
Date: Sun, 15 May 2011 17:51:25 +0200
Message-Id: <1305474685.17656.2.camel@konomi>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi!
> > Backtrace from QEMU ... I think this is what Cyril observed. But heck,
> > it   happens in QEMU too ;-)
> 
> Yes, that is pretty much it.
> 
> It happens randomly, eg. adding printk() line into kernel code
> (somewhere in mmc stack). Or sometimes crashes in the pccard
> initalization when two cards are inserted at the boot time.
>

It happens randomly in qemu too.
 
> -- 
> metan

