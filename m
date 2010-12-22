Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab0LVU2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 15:28:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35386 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab0LVU2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 15:28:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=nS+GBCUn0+zU3FW9VMB4r1Q7CkMUbUIJkmi7hiYw+0d5ntT6HtOn+82MwvtcVbiP4w
         lKtqYNj/pGW6saKHAzI4ZgpIwyND99xfFOxKYRlv/NwnYYlXlF7E1FQMmxPpYxhMShFw
         qS6l9V/pLsjigsA74293hNlB480eXadiqpfoI=
MIME-Version: 1.0
In-Reply-To: <1292970355.2618.76.camel@work-vm>
References: <cover.1292512461.git.richard.cochran@omicron.at>
 <880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
 <AANLkTi=yGoFwYt4p_LeHtAQyYgmURspO-p57UdL0sUEZ@mail.gmail.com>
 <20101221075612.GA13626@riccoc20.at.omicron.at> <AANLkTimJd5pScKTiDxuYd-h+NevYbCusyvUAqmUDXe8h@mail.gmail.com>
 <1292970355.2618.76.camel@work-vm>
From: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Date: Thu, 23 Dec 2010 05:27:58 +0900
Message-ID: <AANLkTimmTzH8+fSYmbajqZ+hU5Ps-UZaTp_1TYzjHB6P@mail.gmail.com>
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

On Wed, Dec 22, 2010 at 7:25 AM, john stultz <johnstul@us.ibm.com> wrote:
> I don't see why that would be better then adding a
> clear new mode flag?

In short, time step is a special case of time slew.  Those are the same,
only different in one parameter, as is shown in my previous post.
That's why I said there's no need for adding a new mode.
