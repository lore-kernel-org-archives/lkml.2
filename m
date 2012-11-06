Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417Ab2KFB0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 20:26:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab2KFB0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 20:26:44 -0500
Date: Tue, 6 Nov 2012 02:26:23 +0100
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David =?ISO-8859-1?B?SORyZGVtYW4=?=" <david@hardeman.nu>,
        "Bruno =?ISO-8859-1?B?UHLpbW9udA==?=" <bonbons@linux-vserver.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20121106022623.4e14cee1@gaivota.chehab.kubiwireless.com>
In-Reply-To: <20121105113409.d3f52085b5f7227b03df0ba4@canb.auug.org.au>
References: <20121029111403.911c815a3c7d8d9572ff8e89@canb.auug.org.au>
	<20121105113409.d3f52085b5f7227b03df0ba4@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Em Mon, 5 Nov 2012 11:34:09 +1100
Stephen Rothwell <sfr@canb.auug.org.au> escreveu:

> Hi Mauro,
> 
> On Mon, 29 Oct 2012 11:14:03 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the v4l-dvb tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > drivers/hid/hid-picolcd_cir.c: In function 'picolcd_init_cir':
> > drivers/hid/hid-picolcd_cir.c:119:27: error: 'RC_TYPE_ALL' undeclared (first use in this function)
> > 
> > Caused by commit c003ab1bedf0 ("[media] rc-core: add separate defines for
> > protocol bitmaps and numbers").  The new reference was introduced in
> > commit ae08e324146c ("HID: picoLCD: Add support for CIR") which was
> > merged by Linus on October 2 into v3.7-rc1 via the hid tree.
> > 
> > I have used the v4l-dvb tree from next-20121026 for today.
> 
> I still get this today.

Not sure what happened, as I think I pushed it on my -next tree. I'm abroad
this week for LinuxCon Europe. Unfortunately, hotel's network blocks almost all
TCP ports, except for web ports. I'm seeing if this can be fixed tomorrow.
If so, I'll be pushing the patches tomorrow night.

Cheers,
Mauro
