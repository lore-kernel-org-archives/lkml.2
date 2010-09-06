Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0IFSrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:47:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54762 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab0IFSre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:47:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernation to hang
Date: Mon, 6 Sep 2010 20:46:43 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "M. Vefa Bicakci" <bicave@superonline.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>
References: <20100903105216.B65C.A69D9226@jp.fujitsu.com> <201009040344.42342.rjw@sisk.pl> <20100906090528.C8A9.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100906090528.C8A9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009062046.43513.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 06, 2010, KOSAKI Motohiro wrote:
> > > ok, thanks. probably I've catched your point. please feel free to use my reviewed-by
> > > for your fix.
> > 
> > Thanks.
> > 
> > In the meantime, though, I prepared a patch that should address the issue
> > entirely.  The patch is appended and if it looks good to you, I'd rather use it
> > instead of the previous one (it is still untested).
> 
> Yeah, this one looks nicer to me :)
> 
> Thanks, rafael!

OK, I'll put it into my linux-next branch, then.

Probably, though, I should modify the changelog, because what it really does
is to check if it makes sense to try to allocat from non-highmem pages, but it
doesn't really prevent the OOM from occuring.

Thanks,
Rafael
