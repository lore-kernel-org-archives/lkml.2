Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966481Ab2FBIBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 04:01:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63498 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965443Ab2FBIBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 04:01:49 -0400
Subject: Re: [PATCH] tty: add lockdep annotations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1338623708.2760.1691.camel@edumazet-glaptop>
References: <4FC6189B.9080909@fusionio.com>
	 <1338402812.2760.413.camel@edumazet-glaptop>
	 <4FC66D3D.6080509@fusionio.com>
	 <1338404902.2760.451.camel@edumazet-glaptop>
	 <1338410107.2760.544.camel@edumazet-glaptop>
	 <1338456918.2760.1318.camel@edumazet-glaptop>
	 <1338574627.2760.1545.camel@edumazet-glaptop>
	 <CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
	 <1338583498.2760.1648.camel@edumazet-glaptop>
	 <20120601215620.305155c0@pyramind.ukuu.org.uk>
	 <1338584389.2760.1653.camel@edumazet-glaptop>
	 <1338621438.2760.1679.camel@edumazet-glaptop>
	 <1338623708.2760.1691.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jun 2012 10:01:42 +0200
Message-ID: <1338624102.2760.1693.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-02 at 09:55 +0200, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> On Sat, 2012-06-02 at 09:17 +0200, Eric Dumazet wrote:
> 
> > 
> > Here is the patch I am currently testing (need to boot the machine ~50
> > times to make sure it is the right fix)
> 
> Seems good, but am still doing reboots to make sure.

Nope, still get a crash at 15th boot.

I have to run.



