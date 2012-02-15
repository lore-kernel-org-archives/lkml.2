Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463Ab2BOCAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 21:00:35 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60930 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab2BOCAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 21:00:34 -0500
Date: Wed, 15 Feb 2012 09:39:58 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venki Pallipadi <venki@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
Message-ID: <20120215013958.GA24229@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1328560933-3037-1-git-send-email-venki@google.com>
 <1328901567.25989.51.camel@laptop>
 <CABeCy1aUj9MM8YabvvQCYYFm4FNMsomU3PZ1ZyoKikL9hnc9uQ@mail.gmail.com>
 <20120213053410.GB24636@zhy>
 <1329227537.2293.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1329227537.2293.1.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 02:52:17PM +0100, Peter Zijlstra wrote:
> On Mon, 2012-02-13 at 13:34 +0800, Yong Zhang wrote:
> > Yeah, most of the things could be shared. Such as the added logic when
> > return from idle and the hooks into ttwu_queue_remote() and
> > generic_exec_single().
> > 
> 
> The thing is, those last two should not have hooks. 

Yeah, it's general place; and smp_need_ipi() plays well.

> Nor am I convinced
> anything outside of the arch idle loop should have any.

'idle loop' is the key point :)

Thanks,
Yong
