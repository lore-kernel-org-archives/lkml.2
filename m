Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab0LUVNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:13:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40610 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab0LUVNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 16:13:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=sTiab6KLOP6527m/a1QfN2d/xy48kTiDSpVLE5g4pBhi9tVDngVwQ2gTgdhOahy40y
         J6aRfvu0QyELoQi+ZLTT1mSy4LYl42Fceak+v21Hy+1Eq16GzFs84Y1LUnk3LS4Z8dCb
         J37kvO3TPmDoUADcjtVMH6E650VkhwNmOcmEM=
MIME-Version: 1.0
In-Reply-To: <1292960224.2618.4.camel@work-vm>
References: <cover.1292512461.git.richard.cochran@omicron.at>
 <880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
 <AANLkTi=yGoFwYt4p_LeHtAQyYgmURspO-p57UdL0sUEZ@mail.gmail.com> <1292960224.2618.4.camel@work-vm>
From: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Date: Wed, 22 Dec 2010 06:13:06 +0900
Message-ID: <AANLkTikHV-qN73Zvvvxn76vtFFKG_VNTQhF3qpqTnOrE@mail.gmail.com>
Subject: Re: [PATCH V7 1/8] ntp: add ADJ_SETOFFSET mode bit
To: john stultz <johnstul@us.ibm.com>
Cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 4:37 AM, john stultz <johnstul@us.ibm.com> wrote:
> adjtimex is a linux specific interface, which is compatible but not
> identical to the ntp specified interfaces. The ntp client code already
> has Linux specific modifications, so I don't think we have to worry
> about 0x40 specifically being reserved by the NTP client.

But struct timex is not linux-specific...
