Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab0LVHNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 02:13:25 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:53559 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab0LVHNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 02:13:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jxIG9bHDtUrMl54bwM9Gk8xWW4Zs4aGBxI3GU2AGs8FgOUm3fL4FFbJAAXeihNmn6o
         qHwzvyt7ovGroe1w3YCSpB9il/yfGqFz6/evu0n1K2ekUthnKgL+L1xWb1yS/zBpRhYt
         /33c51E+BjR7frSIdUvVSrwD2C4+OWy99ElaE=
Date: Wed, 22 Dec 2010 08:13:19 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V7 1/8] ntp: add ADJ_SETOFFSET mode bit
Message-ID: <20101222071319.GB8627@riccoc20.at.omicron.at>
References: <cover.1292512461.git.richard.cochran@omicron.at>
 <880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
 <AANLkTi=yGoFwYt4p_LeHtAQyYgmURspO-p57UdL0sUEZ@mail.gmail.com>
 <20101221075612.GA13626@riccoc20.at.omicron.at>
 <AANLkTimJd5pScKTiDxuYd-h+NevYbCusyvUAqmUDXe8h@mail.gmail.com>
 <1292970355.2618.76.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292970355.2618.76.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 02:25:55PM -0800, john stultz wrote:
> On Wed, 2010-12-22 at 05:57 +0900, Kuwahara,T. wrote:
> 
> > How about this?
> > 
> > if (txc->modes & ADJ_OFFSET) {
> > 	if (txc->constant == INT32_MIN) {
> > 		/* step time */
> > 	} else {
> > 		/* slew time */
> > 	}
> > }
> 
> This looks like magic behavior. Sort of a "knock twice and then say the
> password" interface. I don't see why that would be better then adding a
> clear new mode flag?

I have to agree with John on this one. Looks very hacky to me.

Richard
