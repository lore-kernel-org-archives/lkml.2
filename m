Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab1DYDEs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 23:04:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758082Ab1DYDE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 23:04:29 -0400
Date: Sun, 24 Apr 2011 20:01:41 -0700
From: Greg KH <gregkh@suse.de>
To: Jimmy Chen =?utf-8?B?KOmZs+awuOmBlCk=?= <jimmy.chen@moxa.com>,
        linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/2] misc: add real function open/read/write/ioctl/close
 for moxa_serial_io driver
Message-ID: <20110425030141.GA23658@suse.de>
References: <ECB3782BB8F03341905DD923270296115D5AC2@mhqms01.moxa.com>
 <1303699643.1745.7.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1303699643.1745.7.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 24, 2011 at 07:47:23PM -0700, Joe Perches wrote:
> On Mon, 2011-04-25 at 10:35 +0800, Jimmy Chen (陳永達) wrote:
> > Add real function and GPL license.
> > Signed-off-by: Jimmy Chen <jimmy.chen@moxa.com>
> 
> A few things.
> 
> o Your patches are reversed.
> o Please run your patches through checkpatch.
> o I think it better to avoid duplicating all of the GPL
>   and just reference it as you have via MODULE_LICENSE.
> o You could probably use MODULE_LICENSE("GPL V2")
>   if you want to limit it to V2 only.

And finally, why does this need to be a kernel driver at all?  Can't you
do all of this from userspace without any kernel changes needed?

thanks,

greg k-h
