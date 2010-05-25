Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab0EYO6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 10:58:07 -0400
Received: from thunk.org ([69.25.196.29]:44923 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756413Ab0EYO6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 10:58:06 -0400
Date: Tue, 25 May 2010 10:57:56 -0400
From: tytso@mit.edu
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 5/8] tracing: Convert more ext4 events to DEFINE_EVENT
Message-ID: <20100525145756.GJ5556@thunk.org>
Mail-Followup-To: tytso@mit.edu, Li Zefan <lizf@cn.fujitsu.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
References: <4BFA3728.3000701@cn.fujitsu.com>
 <4BFA37A4.1050208@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFA37A4.1050208@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 04:24:04PM +0800, Li Zefan wrote:
> Use DECLARE_EVENT_CLASS, and save ~2.7K:
> 
>    text    data     bss     dec     hex filename
>  274441    7200     260  281901   44d2d fs/ext4/ext4.o.orig
>  271881    7040     256  279177   44289 fs/ext4/ext4.o
> 
> 4 events are converted:
> 
>   ext4__mb_new_pa: ext4_mb_new_inode_pa, ext4_mb_new_group_pa
>   ext4__mballoc:   ext4_mballoc_discard, ext4_mballoc_free
> 
> No change in functionality.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks, added to the ext4 tree.

					- Ted
