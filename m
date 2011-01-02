Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab1ABJMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 04:12:50 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:33172 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1ABJMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 04:12:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hhh4IsXlz0yl+7yz4PwKcCBWZ4BQPcb2aT2Akpqothg1ECDyBfKIZVdwnpehv/LaKS
         aHubTHdt+0X1va53lNAfzSWKT60OAcznaQuWHoFZ+Ycwqt6zKnFQyck8cXOhGfPEsQL1
         otGVYCxh0Oqd+/+wDngsvJQJav5k8FkQx8e8w=
Date: Sun, 2 Jan 2011 10:12:33 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V7 7/8] ptp: Added a clock driver for the IXP46x.
Message-ID: <20110102091233.GA2847@riccoc20.at.omicron.at>
References: <cover.1292512461.git.richard.cochran@omicron.at>
 <d2e0a5ac5eb51e9e4c7fcc94723b67c72c2f57c1.1292512461.git.richard.cochran@omicron.at>
 <20110102084505.GA3980@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110102084505.GA3980@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 02, 2011 at 09:45:05AM +0100, Pavel Machek wrote:
> Hi!!
> 
> > +struct ixp46x_channel_ctl {
> > +	u32 Ch_Control; /* 0x40 Time Synchronization Channel Control */
> > +	u32 Ch_Event;   /* 0x44 Time Synchronization Channel Event */
> > +	u32 TxSnapLo;   /* 0x48 Transmit Snapshot Low Register */
> > +	u32 TxSnapHi;   /* 0x4C Transmit Snapshot High Register */
> 
> CouldWeGetRidOfCamelCase?

I agree that CamelCase is ugly and in bad taste. However, I make an
exception when the register level programmer's manual uses this style.

IMHO, it is better to use the exact same mnemonics as in the
manual. That way, when the next person comes along to make a change to
the code, with manual in hand, he will immediately know what is what.

Thanks,
Richard
