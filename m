Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab0LYUjl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 15:39:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54718 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab0LYUjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 15:39:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=un3AfhS7pJ5MpuvWkSWeTkR3KMOt11OXJdKmW/4VdvOAX5E6lAGMx/fr+qFCTV5wIJ
         kclJ/ODzRJvPGgIxiiWr0U3IUyExExOw8Meq8j0F3WCrPaHMnbNW0xFkSC2S112Kzrzp
         hWdn/lM0csgusMtUCw8YK0epir9oPKCr0c1h0=
MIME-Version: 1.0
In-Reply-To: <20101223061359.GA7169@riccoc20.at.omicron.at>
References: <cover.1292512461.git.richard.cochran@omicron.at>
 <880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
 <AANLkTi=yGoFwYt4p_LeHtAQyYgmURspO-p57UdL0sUEZ@mail.gmail.com>
 <20101221075612.GA13626@riccoc20.at.omicron.at> <AANLkTimJd5pScKTiDxuYd-h+NevYbCusyvUAqmUDXe8h@mail.gmail.com>
 <1292970355.2618.76.camel@work-vm> <AANLkTimmTzH8+fSYmbajqZ+hU5Ps-UZaTp_1TYzjHB6P@mail.gmail.com>
 <20101223061359.GA7169@riccoc20.at.omicron.at>
From: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Date: Sun, 26 Dec 2010 05:38:57 +0900
Message-ID: <AANLkTind84BVd=2Z07Sz+JfpVRH7m8wdx37YhRcqkCZv@mail.gmail.com>
Subject: Re: [PATCH V7 1/8] ntp: add ADJ_SETOFFSET mode bit
To: Richard Cochran <richardcochran@gmail.com>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
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

After all, I'd prefer your earlier patchset.  Leaving aside the
compatibility issue, there's no particular reason we have to re-use
the struct timex, which requires otherwise unnecessary conditional
branches as well as unit conversions.  Don't you agree?
