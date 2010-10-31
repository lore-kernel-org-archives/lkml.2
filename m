Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab0JaKll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 06:41:41 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46699 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174Ab0JaKlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 06:41:40 -0400
Date: Sun, 31 Oct 2010 11:41:36 +0100
From: Sebastian Andrzej Siewior <bigeasy@breakpoint.cc>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: use after free in serport
Message-ID: <20101031104136.GA511@Chamillionaire.breakpoint.cc>
References: <20101030111618.GA29915@Chamillionaire.breakpoint.cc>
 <4CCD33E6.7000104@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4CCD33E6.7000104@suse.cz>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Slaby | 2010-10-31 10:16:22 [+0100]:

>I think so:
>http://lkml.org/lkml/2010/10/21/223
>
>(the updated patch attached)

Thank you very much the patch, it fixes my problem. The commit that is
causing the bug (65b770468e98, ("tty-ldisc: turn ldisc user count into a
proper refcount")) was merged v2.6.31-rc6~66^2~1. Any chance that you
push it stable once it hits mainline?

>regards,

Sebastian
