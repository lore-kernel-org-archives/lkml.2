Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0IWLtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:49:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47864 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab0IWLs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:48:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mhLCfb7Fp1G/1PFA9koJuEUGeNAEANS1SjyV+GruupYchj85l98FbdXA4X4DA1g0cK
         wX5/6FKO5QZ7fUUYBIPFGeaRQZdA+5t0AHl8AIQfw5r3xrWL8/+qI2ooMfwoTgDiwXU2
         AlE0RemwhlhHoSpLhcqEs4pANn6S1VePeBgBw=
MIME-Version: 1.0
In-Reply-To: <1285224715-30137-1-git-send-email-mfm@muteddisk.com>
References: <1285224715-30137-1-git-send-email-mfm@muteddisk.com>
Date: Thu, 23 Sep 2010 13:48:57 +0200
Message-ID: <AANLkTinzTKdjAqWB-US-Nh2CM+MzL+iuedWScCCaH+mX@mail.gmail.com>
Subject: Re: [PATCH 20/20] net: change to new flag variable
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: matt mooney <mfm@muteddisk.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

matt mooney wrote:
> Replace EXTRA_CFLAGS with ccflags-y.
Thank you,
CAIF parts looks good to me.

Acked-by: Sjur Braendeland <sjur.brandeland@stericsson.com>
