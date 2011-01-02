Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab1ABJUD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 04:20:03 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47252 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab1ABJUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 04:20:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ufybp2DcNB3M7If15GL8rPMG7Dpfa2HRaVSK+a1lAq6VRDGSgbo6t/8x8tsIjrsg4G
         A+LcAENHf15PQ6LHhVDTHs1qSScZ8zk3LXrypcnPz4eVsOifKQ6tv+ZHWwDnpunHoWdN
         I6mJwDqs374ldBlYGkJLVfTEBGNcDPLJgY48w=
Date: Sun, 2 Jan 2011 10:19:49 +0100
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
Message-ID: <20110102091949.GB2847@riccoc20.at.omicron.at>
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

BTW, I posted an updated V8 of this patch series on December 31.

Richard
