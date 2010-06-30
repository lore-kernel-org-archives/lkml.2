Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0F3Hyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 03:54:38 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58191 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0F3Hyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 03:54:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wz1xXstE0LXaYgI+EAmlU4KeGCBdtd4sBWvESvZ+6/XJ848YW+3uTVLDJxMooR2eZj
         zT1kmL4yukXiDbaa7MWP8KSzVyJOoOnPTcK8dlMAKHKDmC1EUAA7XJ9sAfrYnDST0arO
         8M6EOZJFhC23RrJTbcrbZQLyklYwJIObOJI4Y=
MIME-Version: 1.0
In-Reply-To: <AANLkTimK-J1rOYl9p7GX5V99s8GbobMIg4xS0JgKDz_H@mail.gmail.com>
References: <1277069085-30634-1-git-send-email-linus.walleij@stericsson.com> 
	<AANLkTinvHjRuivplcznQP26B5tkdkA1U9y8rfDBuToDQ@mail.gmail.com> 
	<AANLkTimK-J1rOYl9p7GX5V99s8GbobMIg4xS0JgKDz_H@mail.gmail.com>
From: CoffBeta <coffbeta@gmail.com>
Date: Wed, 30 Jun 2010 15:54:21 +0800
Message-ID: <AANLkTincM7nEbRk_zsYrMiD_pMTpH8sagh5ehLkQTUfA@mail.gmail.com>
Subject: Re: [PATCH 01/19] DMAENGINE: ste_dma40: fixed lli_max=1 issue
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Per Friden <per.friden@stericsson.com>,
       Jonas Aaberg <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yes

On Tue, Jun 29, 2010 at 19:31, Linus Walleij <linus.ml.walleij@gmail.com> wrote:
> 2010/6/29 CoffBeta <coffbeta@gmail.com>:
>
>>  maybe this then for drivers which cannot accept sleeping gpios:
>
> What? This is a patch to a DMA driver.
>
> Are you pushing the wrong key or a new type of spam robot? :-?
>
> Yours,
> Linus Walleij
>
