Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149Ab2JEGko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 02:40:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42478 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2JEGkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 02:40:41 -0400
Date: Thu, 4 Oct 2012 23:12:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Gerecke <killertofu@gmail.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: linux-next: build failure after merge of the input tree
Message-ID: <20121005061236.GA11112@core.coreip.homeip.net>
References: <20121005114712.02361628ba297ef695d54876@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005114712.02361628ba297ef695d54876@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Oct 05, 2012 at 11:47:12AM +1000, Stephen Rothwell wrote:
> Hi Dmitry,
> 
> After merging the input tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/input/tablet/wacom_sys.c: In function 'wacom_get_sibling':
> drivers/input/tablet/wacom_sys.c:643:23: error: 'struct usb_device' has no member named 'children'
> 
> Caused by commit 316f18bba311 ("Input: wacom - handle split-sensor
> devices with internal hubs") interacting with commit ff823c79a5c3 ("usb:
> move children to struct usb_port") that is now in Linus' tree.
> 
> I have used the input tree from next-20121004 for today.

Sorry about this. I pulled the offending patch and another one depending
on it out of my next branch pending my next pull from mainline.

Thanks.

-- 
Dmitry
