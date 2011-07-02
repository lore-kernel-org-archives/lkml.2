Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1GBKLJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 06:11:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:37549 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab1GBKLH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 06:11:07 -0400
Subject: Re: [PATCH] plist: add mutex to the blessed lock type for plists
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dima Zavin <dima@android.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1309473918.26417.115.camel@gandalf.stny.rr.com>
References: <1309376033-32005-1-git-send-email-dima@android.com>
	 <m2tyb81jml.fsf@firstfloor.org>
	 <CAPz4a6CbzEm3QJZ-5wsaiSH1H9g7tgo7E7-HyRB8Fv5=NfGDRQ@mail.gmail.com>
	 <1309380221.26417.50.camel@gandalf.stny.rr.com>
	 <CAPz4a6AHuBLfXPx4aXew0BCa3bQ-_kAnrpw_3f2r-5A9OhTTsg@mail.gmail.com>
	 <1309473918.26417.115.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 02 Jul 2011 12:09:50 +0200
Message-ID: <1309601390.10073.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 18:45 -0400, Steven Rostedt wrote:
> On Thu, 2011-06-30 at 15:14 -0700, Dima Zavin wrote:
> > Steve,
> > 
> > So what would do you recommend I do? Is this patch acceptable or do
> > you want me to remove all the debug stuff and modify all the users to
> > not provide a lock?
> > 
> 
> I'm fine either way. I would like to know what Thomas, Ingo and Peter
> think.

I've always been annoyed with that check, just rip it out.
