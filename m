Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab0HVLYG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 07:24:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60489 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab0HVLYE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 07:24:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OU0oXP5M/G2BA+SHtHSZIF8wgm8KaKAvjL2fwWwDPmwGCnQAGnSA3Qqy932VaNEqSM
         mbD6CysxFxFMq4eFXfYSQIp3zmIf6dwx3Zr/ZGe1y6QpZ3H/rqG4OvZyjDoTtmWejmcv
         Kr/KyApUbwZP0gXbU1DuxJEx9hUNH7yp3e24w=
MIME-Version: 1.0
In-Reply-To: <1282475544-24708-1-git-send-email-xiaosuo@gmail.com>
References: <1282475544-24708-1-git-send-email-xiaosuo@gmail.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Sun, 22 Aug 2010 19:23:42 +0800
Message-ID: <AANLkTin1BOgHBc4sTwFAmQhKFNvZ+90herc4Dsh9P8y2@mail.gmail.com>
Subject: Re: [PATCH] net: define __packed for the userspace code
To: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 22, 2010 at 7:12 PM, Changli Gao <xiaosuo@gmail.com> wrote:
> This commit
>
>  commit bc10502dba37d3b210efd9f3867212298f13b78e
>  Author: Eric Dumazet <eric.dumazet@gmail.com>
>  Date:   Thu Jun 3 03:21:52 2010 -0700
>
>    net: use __packed annotation
>
> makes use of __packed in the userspace code. So we'd better define __packed
> for the userspace code too.
>

Oh, sorry. This patch can't work as include/linux/compiler.h isn't
exported to the userspace. But where should we define __packed for the
userspace code? include/linux/types.h?


-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
