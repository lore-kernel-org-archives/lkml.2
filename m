Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab1ENOcs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 10:32:48 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47020 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab1ENOcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 10:32:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GNjFLQN93fK9AjUdVbW6nhh4+TvxQIdtrcMxMxZEiZifZlztgTdj85wZJoCpwBh4dM
         dmWzMc1j3a4BHbBORGAaTwqy3e8vILDrJsAuYZl6oNad+Ri/23cP+biMPG3U596VstOT
         bRvpy4j/gxavqWorqBZJWzisQ8o2YxMP2GQHA=
MIME-Version: 1.0
In-Reply-To: <20110514161436.570ffd93@absol.kitzblitz>
References: <20110514134307.GA3603@maxin>
	<20110514161436.570ffd93@absol.kitzblitz>
Date: Sat, 14 May 2011 17:32:46 +0300
Message-ID: <BANLkTi=DaDCd9XOj4XpXUq2pcKS=jhCdRQ@mail.gmail.com>
Subject: Re: [PATCH] net: ipv6: mcast: Removing invalid check
From: Maxin B John <maxin.john@gmail.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: kaber@trash.net, yoshfuji@linux-ipv6.org, jmorris@namei.org,
        pekkas@netcore.fi, kuznet@ms2.inr.ac.ru, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ahhh.. Another bogus report from Coverity.

>
> I don't see that. We are within a 'for' loop, and some lines
> below you will find an assignment of 'first = 0;'.
>

Thanks a lot for pointing it out.

Best Regards,
Maxin B John
