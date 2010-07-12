Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab0GLRlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:41:17 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:37085 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab0GLRlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:41:15 -0400
Date: Mon, 12 Jul 2010 19:41:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Modpost error after changing CONFIG_SOUND from m to y
Message-ID: <20100712174114.GA17431@merkur.ravnborg.org>
References: <201007120554.16459.vda.linux@googlemail.com> <20100712100301.db1d3980.randy.dunlap@oracle.com> <AANLkTin88f83UV4HcqKtaXS7F2hMTe8YVJPpE-XLmo5J@mail.gmail.com> <20100712172847.GA17423@merkur.ravnborg.org> <AANLkTimTdQRCoWzCYZ7yBLYsKr4P812n8UR678hktJbO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimTdQRCoWzCYZ7yBLYsKr4P812n8UR678hktJbO@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > What is the intial reason why you assign CFLAGS_KERNEL and CFLAGS_MODULE?
> 
> I want to add some flags to every compiler invocation.

    make KCFLAGS=-DMYSTUFF

is what you want to use then.

It is documented in Documentation/kbuild/kbuild.txt (briefly though).

	Sam
