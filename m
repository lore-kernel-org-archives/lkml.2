Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab2FCTo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 15:44:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:32959 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab2FCToX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 15:44:23 -0400
Subject: Re: [PATCH] tty: add lockdep annotations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <CA+55aFzNQe6WCHKBrs_xNY0MxzF4C9jpfLFjSh8GBFTEzGnxxg@mail.gmail.com>
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
	 <1338624102.2760.1693.camel@edumazet-glaptop>
	 <20120602125723.5b057570@pyramind.ukuu.org.uk>
	 <1338640231.2760.1704.camel@edumazet-glaptop>
	 <CA+55aFwXrX16ufu1yf_D8rXTPXfpN1D72STuNYOMqT57je+jRA@mail.gmail.com>
	 <CA+55aFysA72FVTF6k=HnqYjCTqXQO+jcMLeR6MpM=eJm-H+EBQ@mail.gmail.com>
	 <20120602211917.14275f12@pyramind.ukuu.org.uk>
	 <CA+55aFzNQe6WCHKBrs_xNY0MxzF4C9jpfLFjSh8GBFTEzGnxxg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 03 Jun 2012 21:44:18 +0200
Message-ID: <1338752658.2760.1708.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-02 at 15:25 -0700, Linus Torvalds wrote:

> Eric, does this make things work for you again? When/if we get the
> locking sorted out for the tty install/lookup/remove, we can revert
> this revert and do the locking fixes on top of that.

Linus, I confirm all is good with 3.5-rc1

Thanks


