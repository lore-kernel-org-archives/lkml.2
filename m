Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab1I2T2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:28:49 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:51212 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757486Ab1I2T2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:28:47 -0400
Subject: Re: Oops in ecryptfs (apparently) with 3.1-rc6
From: Luciano Coelho <coelho@ti.com>
To: Tyler Hicks <tyhicks@canonical.com>
Cc: ecryptfs@vger.kernel.org, kirkland@canonical.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110929143058.GA15933@boyd>
References: <1316781869.4051.7.camel@cumari>
	 <1317235816.2171.158.camel@cumari>  <20110929143058.GA15933@boyd>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Sep 2011 22:28:42 +0300
Message-ID: <1317324522.2171.170.camel@cumari>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 09:30 -0500, Tyler Hicks wrote: 
> On 2011-09-28 21:50:15, Luciano Coelho wrote:
> > On Fri, 2011-09-23 at 15:44 +0300, Luciano Coelho wrote: 
> > > [255264.517399] Call Trace:
> > > [255264.517406]  [<ffffffff81163f35>] ? vfs_read+0xc5/0x190
> > > [255264.517409]  [<ffffffff8125e0b2>] ecryptfs_decrypt_page+0xb2/0x190
> > > [255264.517413]  [<ffffffff8125bb08>] ecryptfs_readpage+0xd8/0x120
> > > [255264.517418]  [<ffffffff8110daf4>] generic_file_aio_read+0x234/0x740
> > > [255264.517424]  [<ffffffff8125863c>] ecryptfs_read_update_atime+0x1c/0x60
> > > [255264.517428]  [<ffffffff811637fa>] do_sync_read+0xda/0x120
> > > [255264.517434]  [<ffffffff81286a3b>] ? security_file_permission+0x8b/0x90
> > > [255264.517438]  [<ffffffff81163f35>] vfs_read+0xc5/0x190
> > > [255264.517441]  [<ffffffff81164101>] sys_read+0x51/0x90
> > > [255264.517446]  [<ffffffff815dc082>] system_call_fastpath+0x16/0x1b
> > > [255264.517448] Code: 98 41 0f af c5 89 85 58 ff ff ff 49 8b 44 24 40 48 89 45 90 e8 c5 4d 37 00 49 8b 44 24 40 49 8b 54 24 20 49 8d 74 24 70 48 89 c7 <ff> 50 10 85 c0 0f 85 40 01 00 00 31 c0 44 89 ea 48 c7 c6 50 cf 
> > > [255264.517481] RIP  [<ffffffff8125dddd>] ecryptfs_decrypt_extent+0x13d/0x360
> > > [255264.517485]  RSP <ffff88031c03db78>
> > > [255264.517487] CR2: 0000000000000010
> > > [255264.517490] ---[ end trace 6beaa9aa4bd67546 ]---
> > 
> > Did anyone else get a similar oops? Or does anyone have any clue what
> > this is about? I haven't seen any fix that could be related to this, so
> > I'm still really wary of using 3.1-rc*. ;)
> 
> I haven't seen that one. Was your kernel build using more than one job?

Yes, I always build my kernel using 20 jobs on my quadcore with 8
threads.


> I'll take a closer look and try to reproduce it here. Thanks for the
> report!

You're welcome.  Let me know if you need any more info.  As I said
originally, I had been using the kernel for about a week before this
happened, so I'm not sure it's easily reproducible.

-- 
Cheers,
Luca.

