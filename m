Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab0LMGDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:03:40 -0500
Received: from mail.perches.com ([173.55.12.10]:2547 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab0LMGDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:03:40 -0500
Subject: Re: [PATCH 3/3] Staging: rt2860: include KERN_* in printk
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "L. Alberto" =?ISO-8859-1?Q?Gim=E9nez?= <agimenez@sysvalve.es>,
        devel@linuxdriverproject.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101213055637.GA1620@bicker>
References: <1292176591-26081-1-git-send-email-agimenez@sysvalve.es>
	 <1292176591-26081-4-git-send-email-agimenez@sysvalve.es>
	 <1292180668.18202.43.camel@Joe-Laptop>  <20101213055637.GA1620@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Dec 2010 22:03:37 -0800
Message-ID: <1292220217.26970.2.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 08:56 +0300, Dan Carpenter wrote:
> On Sun, Dec 12, 2010 at 11:04:28AM -0800, Joe Perches wrote:
> > On Sun, 2010-12-12 at 18:56 +0100, L. Alberto Giménez wrote:
> > for(...)
> > []
> > 		if (i && i % 4 == 0) {
> > 			printk(KERN_CONT "\n");
> > 			printk(KERN_DEBUG "Block %x: ", i / 8);
> > 		}
> > 		printk(KERN_CONT " %04x", InBuf[2]);
> > 	}
> > 	printk(KERN_CONT "\n");
> This is dead code anyway.  Just remove the whole set_eFusedump_Proc()
> function.

That was just to be instructive.

I think the entire staging rt2860 is dead code.



