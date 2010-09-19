Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab0ISITG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 04:19:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43579 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab0ISITD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 04:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Bgw709cI/+mGYc+JEQZTyog+9cCnf8BKLzuKVhZsihPHvnNITs7AHZ38cvJKUz6Bt/
         MdRABs/rCu57rtC2YDxjdKxaLdXPcpE8uor4SBOFdw8xjUfzQ4I+2Mj3uc00tPFDWXB2
         WS2SIBiaVF7kz7+AKMXXL77ZtdPp0jSpsh6TI=
MIME-Version: 1.0
In-Reply-To: <1250228384-19823-1-git-send-email-lrodriguez@atheros.com>
References: <1250228384-19823-1-git-send-email-lrodriguez@atheros.com>
Date: Sun, 19 Sep 2010 11:19:01 +0300
X-Google-Sender-Auth: rwAPBCNywyariZi-_lFmBSmSJAw
Message-ID: <AANLkTi==_Tvt6hosvfKDdd9uivsa5SVPiqSHNg5Ob3-v@mail.gmail.com>
Subject: Re: [PATCH v2] scripts: add typdef removal tool
From: Pekka Enberg <penberg@kernel.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, mcgrof@gmail.com,
        Julia Lawall <julia@diku.dk>, Joe Perches <joe@perches.com>,
        Nicolas Palix <npalix@diku.dk>,
        Yoann Padioleau <yoann.padioleau@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 8:39 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> If you are porting drivers and need to remove tydpefs you can use
> this to help you port the driver faster. Until we don't have a fully
> correct and complete way to do this through Coccinelle spatch we
> might as well help developers porting drivers with something. spatch
> also has a learning curve, people working on staging may not end
> up using it for a while.
>
> Cc: Julia Lawall <julia@diku.dk>
> Cc: Joe Perches <joe@perches.com>
> Cc: Nicolas Palix <npalix@diku.dk>
> Cc: Yoann Padioleau <yoann.padioleau@gmail.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

How come this script never made it to the kernel tree?
