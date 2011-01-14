Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab1ANGob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 01:44:31 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39989 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab1ANGoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 01:44:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pxgN3+ZOoe0nCmJCo5GxPpoIAERmKO636pQR8aZqYRRiXhxnjVFEQjh9r4FyCu79EA
         G268w/93xB06HV3tvNJODciXISQmLWc2iviRE9WZQtyMPMzewS/wVhySpapJFcebdB0u
         L/gWkVMb+yZBZu5G6vp2qyVrr57CdUw1BFzyQ=
MIME-Version: 1.0
In-Reply-To: <20110113082950.6747ebb8@queued.net>
References: <1294919372-1904-1-git-send-email-ratbert.chuang@gmail.com>
 <1294928559.3570.130.camel@edumazet-laptop> <20110113082950.6747ebb8@queued.net>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Fri, 14 Jan 2011 14:44:03 +0800
Message-ID: <AANLkTimsY88hD8HkBvMMTT2cs7vec2p8yUBNfeKsHod2@mail.gmail.com>
Subject: Re: [PATCH] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Andres Salomon <dilinger@queued.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andres,

On Fri, Jan 14, 2011 at 12:29 AM, Andres Salomon <dilinger@queued.net> wrote:
> On Thu, 13 Jan 2011 15:22:39 +0100
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> Le jeudi 13 janvier 2011 à 19:49 +0800, Po-Yu Chuang a écrit :

> No one else mentioned it, so I'll add:
>
> Don't explicitly inline functions unless they're in a header, or you
> have a really good reason (and that reason should probably be described
> in a comment).  Otherwise, just leave off the 'inline' keyword; the
> compiler is smart enough to decide whether a function should be inlined
> or not.

OK, fixed.

Thanks,
Po-Yu Chuang
