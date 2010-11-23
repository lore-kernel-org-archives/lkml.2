Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab0KWDT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 22:19:58 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34085 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab0KWDT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 22:19:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qdv2JCRPqwj/1xgcJvla7fL4dKUK3nl8omdlKYIr/arlKmQ0AVx8QJcg07bYKp+Nuj
         jURa6DkuY6v97HmNq4RubZvSVIiy4ZF3h5DbMT2e1e5+Xk03nzPsl77NCUbw/Gw1tcIv
         R0yUG6ifMBgrxGXkBHqQmUS2lpDmgBtd2PpkU=
Subject: Re: [PATCH] generic-ipi: add lock context annotations
From: Namhyung Kim <namhyung@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1290430003.2072.101.camel@laptop>
References: <1290411232-11439-1-git-send-email-namhyung@gmail.com>
	 <1290430003.2072.101.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 12:19:50 +0900
Message-ID: <1290482390.1857.26.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-11-22 (월), 13:46 +0100, Peter Zijlstra:
> On Mon, 2010-11-22 at 16:33 +0900, Namhyung Kim wrote:
> > The ipi_call_[un]lock[_irq] functions grab/release a spin lock
> > but were missing proper annotations. Add it.
> 
> I really have to ask why bother? Why not add some smarts to whatever
> uses these annotations?

I just thought that removing bogus warnings from sparse helps us focus
on real issues when using it. Currently sparse emits too many messages
and some (many?) of them might be removed trivially (or by adding bit of
ugliness. :( )

BTW, I didn't get what you mean about "some smarts". Could you explain
them little more?

Thanks.

-- 
Regards,
Namhyung Kim


