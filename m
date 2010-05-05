Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161Ab0EEJJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:09:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44176 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab0EEJJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:09:35 -0400
Subject: Re: [PATCH V2] lockdep: reduce stack_trace usage
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang@windriver.com>
Cc: John Kacur <jkacur@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       "David S. Miller" <davem@davemloft.net>,
       Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <20100505013119.GA20236@windriver.com>
References: <alpine.LFD.2.00.1004222208310.3155@localhost>
	 <20100423025850.GA21328@windriver.com>
	 <alpine.LFD.2.00.1004230907050.4151@localhost>
	 <1272009915.1646.25.camel@laptop>
	 <w2v520f0cf11004230131i743c596emfd0e5b8870330a8b@mail.gmail.com>
	 <20100423134044.GA2777@zhy-desktop> <20100504065711.GC10784@windriver.com>
	 <1272977811.5605.183.camel@twins>  <20100505013119.GA20236@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 11:09:26 +0200
Message-ID: <1273050566.1642.230.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 09:31 +0800, Yong Zhang wrote:
> On Tue, May 04, 2010 at 02:56:51PM +0200, Peter Zijlstra wrote:
> > Right, this looks like it ought to do as intended.
> > 
> > I added the below snipped because I know I'll fail to remember and that
> > 'static' qualifier is fairly easy to miss.
> 
> OK. Thanks for your comments.
> 
> BTW, do you need me resend the patch with your comments in?

No, I've got it.

