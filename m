Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab1EWPYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:24:44 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:35312 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755498Ab1EWPYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:24:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=oVaZ/u4YZtC2tqyHnbUUGRgoChyOcLhJXB/fjmApRAnTPtEdh/d8w6eYX7CRGPXa39tBtKbzyKKzHY7RATvN6Xwy9IRmU0BvWqdwRCHOoXpZDb6IOhLHFcCmJqBA84Hh;
Date: Mon, 23 May 2011 08:24:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: markgross@thegnar.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the suspend tree
Message-Id: <20110523082440.d417688c.rdunlap@xenotime.net>
In-Reply-To: <20110523141846.GA8122@gvim.org>
References: <20110523150636.ccd83777.sfr@canb.auug.org.au>
	<20110523141846.GA8122@gvim.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011 07:18:46 -0700 mark gross wrote:

> On Mon, May 23, 2011 at 03:06:36PM +1000, Stephen Rothwell wrote:
> > Hi Rafael,
> > 
> > After merging the suspend tree, today's linux-next build (i386 defconfig
> > among others) produced this warning:
> > 
> > kernel/pm_qos_params.c: In function 'pm_qos_power_write':
> > kernel/pm_qos_params.c:420: warning: passing argument 3 of 'kstrtol' from incompatible pointer type
> > include/linux/kernel.h:210: note: expected 'long int *' but argument is of type 's32 *'
> > 
> > Intreoduced by commit 365daa955e03 ("PM: Correct PM QOS's user mode
> > interface to work with ascii input per").
> 
> Gah!  I'm sorry about that.
> 
> attached is a fix.
> 
> 
> --mark
> 
> signed-off-by:markgross <markgross@thegnar.org>

Not in correct format.

> 
> From a8f0587b9ae598be5ca4c3cdda4e0ced6ca9baaf Mon Sep 17 00:00:00 2001
> From: mgross <mgross@cr48>

what is cr48?  conference room 48?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
