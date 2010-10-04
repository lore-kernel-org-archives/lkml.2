Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0JDKi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:38:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39821 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab0JDKi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Su3ILgNI8GLVLKbtToPQwUH3q/9Han4m4mK+pBusbnSst5szPAs+eXmEIE6QKNeeqP
         WGC4rgfmI9fM4nY7RIFVbmavg+doNYb6eb+5ymXQ3NF7dXvEXim+DpS9ZMhnPwSkzGL+
         zH+y3YqPavoyp9QdSdET73DuGtAu/4qR4Zo+0=
Subject: Re: [PATCH] sysctl: fix min/max handling in
 __do_proc_doulongvec_minmax()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        Patrick McHardy <kaber@trash.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
In-Reply-To: <20101004103545.GJ5189@cr0.nay.redhat.com>
References: <1286025469.2582.1806.camel@edumazet-laptop>
	 <20101004085913.GR14068@sgi.com>
	 <1286183058.18293.26.camel@edumazet-laptop>
	 <20101004093439.GG5189@cr0.nay.redhat.com>
	 <1286187030.18293.33.camel@edumazet-laptop>
	 <20101004103545.GJ5189@cr0.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 12:38:21 +0200
Message-ID: <1286188701.18293.57.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 04 octobre 2010 à 18:35 +0800, Américo Wang a écrit :

> Your patch does fix the problem, but seems not a good solution,
> we should skip all min/max checking if ->extra(1|2) is NULL,
> instead of checking it every time within the loop.

Please do submit a patch, we'll see if you come to a better solution,
with no added code size (this is slow path, I dont care for checking it
'every time winthin the loop')







