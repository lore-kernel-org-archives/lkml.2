Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab0GNXLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:11:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53142 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab0GNXLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:11:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=onk8K1GNNRpepKasLdDoG/T2GkRiX99y61XjyrsaKOrk8vpS5RJenVpLiY/IvR5PWl
         6+0f4u8AvrhFBW1ft5tRwKZugzDdqI0fVAf0Bh+BNfzYh0FSm/BbB4hvnFVUETyHxnIx
         PoYp6NimGsEnWmPc4djHzIKGwTaIyJCJOeajA=
MIME-Version: 1.0
In-Reply-To: <AANLkTimYqUZvxaWVvT5FPsW36NTpqLLCqCiSuRAy_ER5@mail.gmail.com>
References: <1277770577-11024-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTimYqUZvxaWVvT5FPsW36NTpqLLCqCiSuRAy_ER5@mail.gmail.com>
Date: Thu, 15 Jul 2010 01:11:32 +0200
Message-ID: <AANLkTinqKHCYeGTLuTtKikcR2IA8TY0vy2tSznxLay0N@mail.gmail.com>
Subject: Re: [PATCH 1/3] DMAENGINE: generic slave channel control
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping on this subject, I have the PL08x driver depending on this
so if it's not OK I have to rewrite that patch soonish.

Also the DMA for PrimeCells use it so I would like to respin that
patch series using this generic control if it is accepted.

As mentions something like this will be needed for us anyway,
so in case it's not OK I'll likely go for more or less the same
struct, just that it is for DMA40 and its clients solely, then on
top of that a PrimeCell interface more or less redefining the
same things again or wrapping it.

Yours,
Linus Walleij
