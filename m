Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab0HYRTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 13:19:16 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57143 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0HYRTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 13:19:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GuDO9ZLUy53QFJ0LrHjasIOeBh2VM3ZizOpBauCsyZlPtcnCf2aH9UyqhKCoYQxozM
         sGsolBr5Sr8EoquWHmkjF1T7LU5RxDojYQuEf/cqSpobCqYPKAfQNkGoJ0v8JpRowxnE
         k80HtC2IOND+lQPIDC6uJmkqx5mQqAGPR9N1w=
MIME-Version: 1.0
In-Reply-To: <1281355646-12941-1-git-send-email-linus.walleij@stericsson.com>
References: <1281355646-12941-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 25 Aug 2010 19:19:14 +0200
Message-ID: <AANLkTikt_GNsswb+EaCTeX=-9oh_+g7XhLA94Gy24kSZ@mail.gmail.com>
Subject: Re: [PATCH 00/14] DMAENGINE: ste_dma40: bugfixes and enhancements
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/9 Linus Walleij <linus.walleij@stericsson.com>:

> This patch series adds a few bugfixes and some enhancements to the
> DMA40 driver. Most should be pretty straight forward, others are
> more elaborate, like the amendments to extend hw job lists at
> runtime if there is already a queued job.

Dan, can these be queued for -next? Shouldn't be any controversial
stuff in them AFAICT.

Yours,
Linus Walleij
