Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab2LTPYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 10:24:13 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50540 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2LTPYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 10:24:03 -0500
Subject: Re: [PATCH] net: ipv4: route: fixed a coding style issues net:
 ipv4: tcp: fixed a coding style issues
From: Eric Dumazet <erdnetdev@gmail.com>
To: nicolas.dichtel@6wind.com
Cc: Stefan Hasko <hasko.stevo@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <50D2FF86.3000603@6wind.com>
References: <1355990910-3688-1-git-send-email-hasko.stevo@gmail.com>
	 <50D2FF86.3000603@6wind.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Dec 2012 07:23:59 -0800
Message-ID: <1356017039.21834.2819.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-20 at 13:07 +0100, Nicolas Dichtel wrote:
> Le 20/12/2012 09:08, Stefan Hasko a écrit :

> > +				"out_hlist_search\n");
> checkpatch will warn you about this one, something like:
> "WARNING: quoted string split across lines".
> Not breaking such line ease to grep the pattern.


Yes.

Could we please leave this file as is for at least 2 years ?

We had a lot of recent changes and probable fixes are expected.

Such "coding style" patches are a real pain when trying to fix bugs,
especially dealing with stable/old kernels.

Thanks


