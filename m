Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032Ab2FURly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 13:41:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5324 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760011Ab2FURlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 13:41:53 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=FlAZEPfbBygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=2nk-Tcjw72y3_uGIgsIA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340300509.27036.185.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Jun 2012 13:41:49 -0400
In-Reply-To: <20120621171338.GF3270@kroah.com>
References: <20120614154153.GD17140@kroah.com>
	 <1339693625.13377.242.camel@gandalf.stny.rr.com>
	 <20120615042233.GA10973@localhost> <20120615043017.GA9587@kroah.com>
	 <20120615120430.GB23681@gmail.com> <20120615231318.GD8205@kroah.com>
	 <1339804415.25903.63.camel@gandalf.stny.rr.com>
	 <20120618230337.GB23627@kroah.com>
	 <1340069326.25903.177.camel@gandalf.stny.rr.com>
	 <20120620122549.GA10561@gmail.com> <20120621171338.GF3270@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 10:13 -0700, Greg Kroah-Hartman wrote:

> > So mind re-sending the latest version of your printk flushing 
> > fix? I'll apply it for v3.5-rc if other trees won't pick it up.
> 
> I'll be glad to pick it up, just make it work properly :)

I'm playing around with making a KERN_FLUSH "<f>". Think that's a better
approach?

-- Steve


