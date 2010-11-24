Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab0KXUN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 15:13:56 -0500
Received: from [71.74.56.122] ([71.74.56.122]:62900 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751389Ab0KXUNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 15:13:55 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=yZSwoSqacEEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=Rxjk4AdAKUsRu0J1G1oA:9 a=hwGcHegxw6uK3kaGS4AA:7 a=4CvYJ8z69y7-rkTnFZuChDN3XAwA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] isdn: icn: Fix stack overflow bug
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, isdn@linux-pingi.de,
        akpm@linux-foundation.org
In-Reply-To: <20101124.112042.179943893.davem@davemloft.net>
References: <1290573578.30543.461.camel@gandalf.stny.rr.com>
	 <1290573987.30543.462.camel@gandalf.stny.rr.com>
	 <20101124.112042.179943893.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 24 Nov 2010 15:13:31 -0500
Message-ID: <1290629611.30543.704.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 11:20 -0800, David Miller wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Tue, 23 Nov 2010 23:46:27 -0500
> 
> > 
> > Note, the subject should really be:
> > 
> > [PATCH] isdn: icn: Fix stack corruption bug.
> 
> Applied.

Thanks,

> 
> Please CC: isdn patches to netdev@vger.kernel.org in the future as per
> "ISDN SUBSYSTEM" in MAINTAINERS.  Patches sent only to the ISDN list
> and Karsten are likely to not get looked at for weeks if not longer.

OK, will do.

That's what I get for sending patches when I'm tired. I only saw the
first mailing list. I didn't even notice the netdev one. And I also
forgot to add the [PATCH] to the original subject.

I wrote the patch while still awake, but ran it through a few more tests
just to make sure it worked. Forgot about it, and then when I was done
with my normal job, I decided to send it out (making change log and
everything).

-- Steve


