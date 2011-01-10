Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab1AJUqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:46:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63826 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab1AJUqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 15:46:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=RJuO+Pix+gGjjIav2xkSvexpPYP5hyffkqSaefiSnwt7/cVxtAJo6/yFkQ2mI8xoE5
         ibGDAFuvN+GG5CD41ePjBqMEMrXylc3OyqXjyaK2zFqmgveRUtZ2kuziDuL4kBm0fuKl
         +ygGThdvud1fzlq9HxxWXwHwkES3eZOgRPHA4=
MIME-Version: 1.0
In-Reply-To: <1294678145.3068.6.camel@work-vm>
References: <cover.1293820862.git.richard.cochran@omicron.at>
 <fe2bec763bec155381d62721aa9da84aeca2785c.1293820862.git.richard.cochran@omicron.at>
 <AANLkTini2WdT-1v4k9V3JOZYDkA59P+SyscTe8-fK2Wk@mail.gmail.com>
 <20110108175028.GA22308@riccoc20.at.omicron.at> <AANLkTikigXGSACF6R6kfNHyKZ7GFWrUrCMxygvL3fUC6@mail.gmail.com>
 <1294678145.3068.6.camel@work-vm>
From: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Date: Tue, 11 Jan 2011 05:45:50 +0900
Message-ID: <AANLkTikdg4Pb5c4wcCU3d3Eku=mpiW_TEkBz0A2VPdVp@mail.gmail.com>
Subject: Re: [PATCH V8 02/13] ntp: add ADJ_SETOFFSET mode bit
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

On Tue, Jan 11, 2011 at 1:49 AM, john stultz <johnstul@us.ibm.com> wrote:
> Leapsecond processing is done via an absolute hrtimer. Thus when the
> time offset is set, the hrtimers that should have expired will fire
> (just like with settimeofday) and the adjustment will then be made.

How do you convert relative time to absolute time?  It's not trivial
because TAI offset is also a variable.
