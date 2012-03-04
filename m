Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab2CDT5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 14:57:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12683 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2CDT5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 14:57:50 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=PCV3zeDV7Q0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=qg3tVdfUC5H87LdwWLEA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 1/2] Netfilter: xt_LOG: Implement ring buffer support
From: Steven Rostedt <rostedt@goodmis.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Richard Weinberger <richard@nod.at>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, jengelh@medozas.de, basti@b-bl.de
In-Reply-To: <20120304190438.GA24722@1984>
References: <1329348480-11147-1-git-send-email-richard@nod.at>
	 <20120304190438.GA24722@1984>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Mar 2012 14:57:37 -0500
Message-ID: <1330891057.2679.18.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-03-04 at 20:04 +0100, Pablo Neira Ayuso wrote:

> > diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> > index b895d8b..ac62599 100644
> > --- a/net/netfilter/Kconfig
> > +++ b/net/netfilter/Kconfig
> > @@ -533,6 +533,19 @@ config NETFILTER_XT_TARGET_LOG
> >  
> >  	  To compile it as a module, choose M here.  If unsure, say N.
> >  
> > +if NETFILTER_XT_TARGET_LOG
> > +
> > +config NETFILTER_XT_TARGET_LOG_RING
> > +	bool  'Ring buffer support'
> > +	default y
> > +	select RING_BUFFER
> 
> Please, CC the ring buffer author, I'm not familar with that code and
> I'll be happy to have an acknowledgment from him stating that the ring
> buffer bits are OK.

I am Cc'd and I believe I did ack his first set of patches. I have to
admit, I haven't looked too deeply at them again. I can review the last
set and give another ack if you want.

-- Steve


