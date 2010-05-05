Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934304Ab0EEJTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:19:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:61498 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934205Ab0EEJTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:19:42 -0400
Date: Wed, 5 May 2010 17:18:40 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: John Kacur <jkacur@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       "David S. Miller" <davem@davemloft.net>,
       Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [PATCH V2] lockdep: reduce stack_trace usage
Message-ID: <20100505091840.GD20236@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <alpine.LFD.2.00.1004222208310.3155@localhost>
 <20100423025850.GA21328@windriver.com>
 <alpine.LFD.2.00.1004230907050.4151@localhost>
 <1272009915.1646.25.camel@laptop>
 <w2v520f0cf11004230131i743c596emfd0e5b8870330a8b@mail.gmail.com>
 <20100423134044.GA2777@zhy-desktop>
 <20100504065711.GC10784@windriver.com>
 <1272977811.5605.183.camel@twins>
 <20100505013119.GA20236@windriver.com>
 <1273050566.1642.230.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1273050566.1642.230.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 05 May 2010 09:18:43.0703 (UTC) FILETIME=[F5562070:01CAEC33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 11:09:26AM +0200, Peter Zijlstra wrote:
> > BTW, do you need me resend the patch with your comments in?
> 
> No, I've got it.

That's great. Thank you. :)
