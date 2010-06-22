Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab0FVNgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 09:36:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64098 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758318Ab0FVNgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 09:36:46 -0400
X-Authority-Analysis: v=1.1 cv=CRXretTPUtnO3YxfLBAQPdv2BUzevxUrVWgTW+Y28TY= c=1 sm=0 a=g4V3m_FLxYQA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=NjbqhjlbWcQNY9nlKLsA:9 a=H0Md_8yX9hHbm_cadNkmS2gqjFgA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH for stable] tracing: Consolidate protection of reader
 access to the ring buffer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
In-Reply-To: <20100622132839.GA18974@suse.de>
References: <1277212983.9181.27.camel@gandalf.stny.rr.com>
	 <20100622132839.GA18974@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 22 Jun 2010 09:36:44 -0400
Message-ID: <1277213804.9181.30.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 06:28 -0700, Greg KH wrote:
> On Tue, Jun 22, 2010 at 09:23:03AM -0400, Steven Rostedt wrote:
> > Greg,
> > 
> > Johannes has been hitting a bug in 2.6.33 that we believe is fixed with
> > the following patch. The bug is hit a few times a week, so it is hard to
> > verify. But we are only hitting it with .33 and not .34, and this patch
> > looks like it would be the one to fix it.
> > 
> > Can you apply this patch to the 2.6.33 stable series.
> 
> If you are ok with it, I'll apply it as it does look a little "big" for
> a stable kernel :)

Yeah, I usually would not ask for a patch this size to go into stable,
but it has been in mainline for a while, and seems to be the fix for a
bug we are hitting in .33.

> 
> I'll queue it up later today.

Great! Thanks,

-- Steve


