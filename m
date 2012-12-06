Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab2LFXhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 18:37:33 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:52651 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754547Ab2LFXhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 18:37:32 -0500
Message-ID: <1354837050.22463.4.camel@joe-AO722>
Subject: Re: [PATCH v2 00/14] printk() fixes, optimizations, and clean ups
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan =?ISO-8859-1?Q?H=2ESch=F6nherr?= <schnhrr@cs.tu-berlin.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 06 Dec 2012 15:37:30 -0800
In-Reply-To: <20121206133907.37c255e9.akpm@linux-foundation.org>
References: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
	 <20121206133907.37c255e9.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-06 at 13:39 -0800, Andrew Morton wrote:
> On Thu,  6 Dec 2012 18:05:57 +0100
> Jan H. Sch__nherr <schnhrr@cs.tu-berlin.de> wrote:
> 
> > This is the second iteration of my try to clean up and fix some bugs around
> > printk().
> 
> We're a few days away from 3.7, which is not a good time to be sending
> large patchsets.  Please resend after -rc1 and I'll take a look.

Hi Andrew, 

I'm pretty sure this isn't for 3.7 but is for 3.8.

> But be aware that Joe is also planning on sending a large
> printk patchset at that time, and the two patchsets will conflict
> massively.

Can you please pick this up for -next now and I'll
redo my patches against -next for -rc1 so I'm not
delayed until 3.9?

cheers, Joe


