Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab2J2IRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 04:17:05 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:37719 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab2J2IRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 04:17:03 -0400
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2012 04:17:03 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 29 Oct 2012 09:09:13 +0100
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
In-Reply-To: <20121029111403.911c815a3c7d8d9572ff8e89@canb.auug.org.au>
References: <20121029111403.911c815a3c7d8d9572ff8e89@canb.auug.org.au>
Message-ID: <8d5c617feaaecfcf9e358a8b2cc35d20@hardeman.nu>
User-Agent: RoundCube Webmail/0.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012 11:14:03 +1100, Stephen Rothwell
<sfr@canb.auug.org.au>
wrote:
> Hi Mauro,
> 
> After merging the v4l-dvb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/hid/hid-picolcd_cir.c: In function 'picolcd_init_cir':
> drivers/hid/hid-picolcd_cir.c:119:27: error: 'RC_TYPE_ALL' undeclared
> (first use in this function)

I can fix it, should be easy (rename RC_TYPE_ALL to RC_BIT_ALL).

> Caused by commit c003ab1bedf0 ("[media] rc-core: add separate defines
for
> protocol bitmaps and numbers").  The new reference was introduced in
> commit ae08e324146c ("HID: picoLCD: Add support for CIR") which was
> merged by Linus on October 2 into v3.7-rc1 via the hid tree.
> 
> I have used the v4l-dvb tree from next-20121026 for today.

The question is in which form you want the patch - as a separate patch or
a new version of commit c003ab1bedf0 (i.e. the entire patch)? Also, against
which tree should I create the patch?


