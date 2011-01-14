Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab1ANIU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 03:20:57 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:56185 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530Ab1ANIUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 03:20:52 -0500
X-Sasl-enc: TgMIfBDMh3bo0KPuBMnbklnGsLYag5ly99t3n1NnUrEF 1294993251
Subject: Re: [autofs] WARNING: at fs/dcache.c:1359 d_set_d_op [was: mmotm
 2011-01-06-15-41 uploaded]
From: Ian Kent <raven@themaw.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, autofs@linux.kernel.org,
        mm-commits@vger.kernel.org, npiggin@kernel.dk,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org
In-Reply-To: <4D2F1CD7.5090100@gmail.com>
References: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
	 <4D2ECB56.4070802@gmail.com> <12521.1294932824@localhost>
	 <4D2F1CD7.5090100@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 16:20:43 +0800
Message-ID: <1294993243.2794.4.camel@perseus>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 16:40 +0100, Jiri Slaby wrote:
> On 01/13/2011 04:33 PM, Valdis.Kletnieks@vt.edu wrote:
> > On Thu, 13 Jan 2011 10:52:22 +0100, Jiri Slaby said:
> >> On 01/07/2011 12:41 AM, akpm@linux-foundation.org wrote:
> >>> The mm-of-the-moment snapshot 2011-01-06-15-41 has been uploaded to
> >>
> >> Hi, after some uptime and several suspend/resume cycles, I got:
> >> WARNING: at fs/dcache.c:1359 d_set_d_op+0x82/0xb0()
> >> Hardware name: To Be Filled By O.E.M.
> >> Modules linked in: dvb_usb_af9015 tda18271 af9013 dvb_usb dvb_core
> >> Pid: 3474, comm: automount Tainted: G        W   2.6.37-mm1_64+ #1344
> >> Call Trace:
> >>  [<ffffffff8106bd2a>] ? warn_slowpath_common+0x7a/0xb0
> >>  [<ffffffff8106bd75>] ? warn_slowpath_null+0x15/0x20
> >>  [<ffffffff81125a32>] ? d_set_d_op+0x82/0xb0
> >>  [<ffffffff8120d829>] ? autofs4_dir_mkdir+0x169/0x180
> > 
> > Wow. So it wasn't just configfs that trips over this one.  I'm now hoping that
> > Al audited all the pseudo file systems for this...
> 
> Well, CCing Al.
> 
> I don't see any recent change in fs/autofs4 in:
> http://git.kernel.org/?p=linux/kernel/git/viro/vfs-2.6.git;a=history;f=fs/autofs4;hb=refs/heads/for-next
> 
> So maybe not all?

Did you see:
https://lkml.org/lkml/2011/1/12/394

Haven't had any feedback on this yet, odd or maybe no news is good news?

Ian


