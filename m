Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab0F2Lbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 07:31:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53036 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab0F2Lbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 07:31:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Sg828yRY9pe0cEEM8FmDwD7g9GAiqObQREDRYasy4OvglMwzOZMWXUgoSO716iwqX4
         Jpe8bb91q6wyajnzGIP7pH66NO4lrnqhk6HWLlTvXx1GUM+3ObxG5v4Vl4ABhsWcHd/k
         nz5ynlsWYBYnOfmcpQWmoqu0jIb1aoVgW1JpA=
MIME-Version: 1.0
In-Reply-To: <AANLkTinvHjRuivplcznQP26B5tkdkA1U9y8rfDBuToDQ@mail.gmail.com>
References: <1277069085-30634-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTinvHjRuivplcznQP26B5tkdkA1U9y8rfDBuToDQ@mail.gmail.com>
Date: Tue, 29 Jun 2010 13:31:36 +0200
Message-ID: <AANLkTimK-J1rOYl9p7GX5V99s8GbobMIg4xS0JgKDz_H@mail.gmail.com>
Subject: Re: [PATCH 01/19] DMAENGINE: ste_dma40: fixed lli_max=1 issue
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: CoffBeta <coffbeta@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Per Friden <per.friden@stericsson.com>,
       Jonas Aaberg <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/29 CoffBeta <coffbeta@gmail.com>:

>  maybe this then for drivers which cannot accept sleeping gpios:

What? This is a patch to a DMA driver.

Are you pushing the wrong key or a new type of spam robot? :-?

Yours,
Linus Walleij
