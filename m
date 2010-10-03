Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab0JCIUi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 04:20:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49632 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab0JCIUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 04:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ug1zlPzPF5fKOMn/ulISItDLaQC3wi4eDYgLnrNefDW/wYjG1WjeJ6R19Q9xtWfb5o
         SjBVHsIMYVIS4nZ50n40e4Vcb7t3sK3q53Zlj/1FzcSGPbjUYbCu6/jjPJJwICEk1wKz
         q00qxEeSTT7FlKluAYrgfZhvIrdaAPBOAkVS4=
MIME-Version: 1.0
In-Reply-To: <20101001203022.GA28486@1wt.eu>
References: <20101001193958.GP14068@sgi.com>
	<20101001203022.GA28486@1wt.eu>
Date: Sun, 3 Oct 2010 01:20:32 -0700
Message-ID: <AANLkTin5wPvFQDFrupqGs_Jbh1rgrTjMupbPUFnvrBrv@mail.gmail.com>
Subject: Re: sysctl_{tcp,udp,sctp}_mem overflow on 16TB system.
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Robin Holt <holt@sgi.com>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Vlad Yasevich <vladislav.yasevich@hp.com>,
        Sridhar Samudrala <sri@us.ibm.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net,
        linux-sctp@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isn't INT_MAX/2 just 1GB, which is only ~0.9 seconds at 10 Gbps?
