Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab2F3UMp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 16:12:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51728 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab2F3UMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 16:12:43 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: linux-next: build failure after merge of the final tree (pwm tree related)
Date: Sat, 30 Jun 2012 20:12:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
References: <20120629174826.546cc991459b12833f2aaebd@canb.auug.org.au> <201206301920.21158.arnd.bergmann@linaro.org> <20120630194139.GA24300@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120630194139.GA24300@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206302012.32476.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:2cl8ZuKAQj7Q/5x4BeyaBWsVxWJxMOZFj3l7ZE1GM6n
 GBS/+lEviIms9R3fgwx6l177ub9G8bkobw6dwU64EQT/99i8pM
 GwBxlNMLSIVKE2HwqOneQ3EoF4EMwqv0oglXMqL6TxZ/AaFtRT
 +DWaenItnX8dBIaU8uEMzrqHOrZwK9sO1h1RKDm3WuWRGKX0wA
 S3S+9yWjvMXYBBbXdVo72/4Xu43gzodXie+ss9IekKEj8k8Pr+
 RfE4vlNANeJcLcgVJdgrdeU8y9jXG+GMlGHx1IIzQyjMmctDkd
 7BNdLOho0PSX/VJ5lDblrFHvuKbnWsb+n/OrE7mKaKKEV5umEL
 uPQ1O8pH1D7321aNfoVONrXq/PGbZVJBdGooZrTvk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 June 2012, Thierry Reding wrote:
> > I think that all the drivers that are not converted to the common PWM
> > layer yet should depend on not enabling the common code. Once they
> > are all moved over, that dependency will go away.
> 
> Right. That's exactly what I meant. If we add depends on !HAVE_PWM to
> the PWM symbol that should result in both options conflicting, and
> therefore not being built at the same time.

But I would add it to all other ones then, not the generic one!

One question though: if the generic pwm implementation does not set
HAVE_PWM, how can a driver check its presence?

	Arnd

