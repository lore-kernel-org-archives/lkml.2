Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab1FVDCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 23:02:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38515 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308Ab1FVDCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 23:02:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ltErtNDwMwSgYSBMVC60zSSAYd6IfBrDe8vvmjIY00K1hZqA1SxY/0uePdzMtxJMLs
         nvFicZHgioT5ucr73OMNMgOelEJ94foqrc1dLoD+ngPO5CN3+FhyP09wNYlQhVLgxLuF
         LcP1FR+WQWWYnc4t3U/4dZuqB9ZnRWIF6KeEQ=
MIME-Version: 1.0
In-Reply-To: <1308708650-25509-1-git-send-email-loke.chetan@gmail.com>
References: <1308708650-25509-1-git-send-email-loke.chetan@gmail.com>
Date: Tue, 21 Jun 2011 23:02:11 -0400
Message-ID: <BANLkTimisxLVdYJTK1NcR1vQi27CE20yxQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next af-packet 0/2] Enhance af-packet to provide
 (near zero)lossless packet capture functionality.
From: chetan loke <loke.chetan@gmail.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: eric.dumazet@gmail.com, joe@perches.com, bhutchings@solarflare.com,
        shemminger@vyatta.com, linux-kernel@vger.kernel.org,
        Chetan Loke <loke.chetan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 10:10 PM, Chetan Loke <loke.chetan@gmail.com> wrote:
> Hello,
>
> Please review the patchset.
>
> Changes from v1:
>
> 1) v1 was based on 2.6.38.9. v2 is rebased to net-next.
> 2) Aligned bdqc members, pr_err to WARN, sob email      (Joe Perches)
> 3) Added tp_padding                                     (Eric Dumazet)
> 4) Nuked useless ;) white space                         (Stephen H)
> 5) Use __u types in headers                             (Ben Hutchings)
> 6) Added field for creating private area                (Chetan Loke)
>

Hi Dave,

Is there a chance of getting this merged either in 3.0 or 3.1 or ever ;) ?

thanks
Chetan
