Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0HaXRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 19:17:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48765 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab0HaXRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 19:17:06 -0400
X-Authority-Analysis: v=1.1 cv=tmcEYLAoDqwcE/92ninAvjUMbWeHvL1caymGjnMU8Ns= c=1 sm=0 a=MSnKhT_c3jYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=vr2eZ6Z_4mSovhOuDXYA:9 a=HLdZo1J5O8llA4vsf3Tn1XJA2kYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [Ksummit-2010-discuss] [PATCH] MAINTAINERS: add U: for URL of
 todo list, add RCU todo list
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Arjan van de Ven <arjan@infradead.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Joe Perches <joe@perches.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org,
        ksummit-2010-discuss@lists.linux-foundation.org
In-Reply-To: <20100831230213.GG2421@linux.vnet.ibm.com>
References: <20100826154537.GA4874@linux.vnet.ibm.com>
	 <1282837904.1875.64.camel@Joe-Laptop>
	 <20100826161451.GB2367@linux.vnet.ibm.com>
	 <1282839933.8133.11.camel@mulgrave.site>
	 <20100826092923.4bdbea69.rdunlap@xenotime.net>
	 <20100826093838.74ab9958@infradead.org>
	 <1283275388.1377.216.camel@gandalf.stny.rr.com>
	 <20100831230213.GG2421@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 Aug 2010 19:17:02 -0400
Message-ID: <1283296622.1377.765.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 16:02 -0700, Paul E. McKenney wrote:

> > We could add a toplevel "todo/" directory, with each project file in it
> > and a list of things todo. When the todo is done, that same commit could
> > remove the todo item.
> > 
> > Just a worthless thought ;-)
> 
> I am with Dmitry on this one.  I really don't want to be prevented from
> updating my todo items outside of the merge window.
> 
> Different people have different needs, so we need to accommodate todo
> lists both within and outside the kernel source tree.

Actually, that would probably happen automatically.

If you are working on a subsystem, you should probably be working
against the git tree for that subsystem. When something is done in the
todo list, the subsystem tree would be updated with the commit that does
said change.

Then, the list is maintained outside of mainline (in the subsystem git
tree) and will automatically update mainline in the next merge window
when the tree is pulled.

-- Steve


