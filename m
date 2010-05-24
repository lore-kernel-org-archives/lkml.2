Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab0EXXWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:22:42 -0400
Received: from tex.lwn.net ([70.33.254.29]:35138 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab0EXXWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:22:40 -0400
Date: Mon, 24 May 2010 17:22:37 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Bruno =?ISO-8859-1?B?UHLpbW9udA==?= <bonbons@linux-vserver.org>,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 5/5] Add the viafb video capture driver
Message-ID: <20100524172237.7c17cd57@bike.lwn.net>
In-Reply-To: <4BF924E3.5020702@redhat.com>
References: <1273098884-21848-1-git-send-email-corbet@lwn.net>
	<1273098884-21848-6-git-send-email-corbet@lwn.net>
	<4BF924E3.5020702@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 May 2010 09:51:47 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> The driver is OK to my eyes. I just found 2 minor coding style issues.
> it is ok to me if you want to sent it via your git tree.
> 
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Great, thanks for taking a look!

All of the precursor stuff is in mainline now, so it can go via whatever
path.  I'll just go ahead and request a pull in the near future unless
somebody objects.

> > +	.sizeimage	= VGA_WIDTH*VGA_HEIGHT*2,
> 
> CodingStyle: please use spaces between values/operators. Not sure why, but
> newer versions of checkpatch.pl don't complain anymore on some cases.

Interesting...for all of my programming life I've left out spaces around
multiplicative operators - a way of showing that they bind more tightly
than the additive variety.  I thought everybody else did that too.
CodingStyle agrees with you, though; I'll append a patch fixing these up.
Learn something every day...

Thanks,

jon
