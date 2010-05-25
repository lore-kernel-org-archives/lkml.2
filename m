Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118Ab0EYPC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:02:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab0EYPC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:02:56 -0400
X-Authority-Analysis: v=1.1 cv=APwCx09NCuKDvl2mjFwkKdJZScS8XOZHPgx3WG6BpL0= c=1 sm=0 a=XXDawb-s1wMA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=bXPKiCD9phwNtV9BRlQA:9 a=NbQ6aCKlRmg5-VENYeoWUA5kQlkA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 5/8] tracing: Convert more ext4 events to DEFINE_EVENT
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: tytso@mit.edu
Cc: Li Zefan <lizf@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org
In-Reply-To: <20100525145756.GJ5556@thunk.org>
References: <4BFA3728.3000701@cn.fujitsu.com>
	 <4BFA37A4.1050208@cn.fujitsu.com>  <20100525145756.GJ5556@thunk.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 25 May 2010 11:02:53 -0400
Message-ID: <1274799773.22648.210.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 10:57 -0400, tytso@mit.edu wrote:
> On Mon, May 24, 2010 at 04:24:04PM +0800, Li Zefan wrote:
> > Use DECLARE_EVENT_CLASS, and save ~2.7K:
> > 
> >    text    data     bss     dec     hex filename
> >  274441    7200     260  281901   44d2d fs/ext4/ext4.o.orig
> >  271881    7040     256  279177   44289 fs/ext4/ext4.o
> > 
> > 4 events are converted:
> > 
> >   ext4__mb_new_pa: ext4_mb_new_inode_pa, ext4_mb_new_group_pa
> >   ext4__mballoc:   ext4_mballoc_discard, ext4_mballoc_free
> > 
> > No change in functionality.
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Thanks, added to the ext4 tree.

You could add...

Acked-by: Steven Rostedt <rostedt@goodmis.org>

if you want.

-- Steve


