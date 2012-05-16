Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab2EPB4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:56:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5661 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223Ab2EPB4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:56:52 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=CaDQJb5GBWIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=TSbVqHtbAAAA:8 a=XThpZ6cEg-kNrrlxqG0A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337133410.6724.25.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH -rt] mm: protect activate_mm() by
 preempt_[disable|enable]_rt()
From: Steven Rostedt <rostedt@goodmis.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Josh Cartwright <joshc@linux.com>, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 15 May 2012 21:56:50 -0400
In-Reply-To: <20120516013802.GA8829@zhy>
References: <1337061236-1766-1-git-send-email-yong.zhang0@gmail.com>
	 <20120515213619.GA8880@joshcartwright.net> <20120516013802.GA8829@zhy>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 09:38 +0800, Yong Zhang wrote:
> On Tue, May 15, 2012 at 05:36:19PM -0400, Josh Cartwright wrote:
> > Frank Rowand posted a very similar fix in December of last year that
> > we've been carrying to fix the same issue:
> > 
> >    http://permalink.gmane.org/gmane.linux.kernel/1229806
> > 
> > It looks like there was some deliberation as to whether or not it should
> > be pulled into stable-rt.  Perhaps its time to revisit this discussion?
> 
> Yeah, thanks for pointing it out, I didn't know there is discussion about
> it.
> 

I believe we can go with Yong's patch. I don't think the #ifdef is
necessary. Just do the preempt_disable_rt().

-- Steve


