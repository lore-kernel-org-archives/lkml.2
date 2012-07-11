Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492Ab2GKXbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 19:31:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14533 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab2GKXbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 19:31:33 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=bNE_EorAjX4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=OEUk1CiJT2WTRxyb2KQA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1342049492.14828.69.camel@gandalf.stny.rr.com>
Subject: Re: [patch RT 0/7] Various fixes for the stable RT series - part I
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        RT-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <cbe@osadl.org>
Date: Wed, 11 Jul 2012 19:31:32 -0400
In-Reply-To: <20120711214552.036760674@linutronix.de>
References: <20120711214552.036760674@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 22:05 +0000, Thomas Gleixner wrote:
> The following patch series is a collection of bug fixes, which should
> go into the 3.x based stable RT trees.
> 
> I have them locally applied to my 3.5 devel queue, but I'm still
> distracted by other events (leap seconds and the like) to get a 3.5
> devel queue released.
> 
> Steven, please pick up the lot.
> 
> I have a part II series pending which is addressing the widely
> observed CPU hotplug issue. I'm going to send that out soon, despite
> the fact that I fundamentaly hate it. Though the hotplug rework which
> I have in the queue has turned out to be more work than expected and
> there is no real way to backport all of the necessary changes into any
> of the existing 3.x based RT trees. So I bite the bullet and go with
> the workarounds to get rid of the last obstacles in the 3.x based RT
> series.

I'll pull these in and start running my tests. I noticed that some of
them are Signed-off-by Carsten first. Did he author them? If so, I'll
make it so his name gets the git author.

Same for Mike Galbraith on patch 6. Only patch 7 has a 'From:' tag.

-- Steve

