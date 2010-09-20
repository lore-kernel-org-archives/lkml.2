Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab0ITNMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 09:12:10 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52379 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab0ITNMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 09:12:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uB5mDG69hjbmUgtZgsLApS+QH06hcILGYvDWUlkqqoxm7g9mAeimlUu2VND0uJUKCQ
         u7y9Sudl18x8BNGtMByxQmR3PUebXozQPbpEh1BNBK5MEMCE/qcZRD0dVLMdywidoLm9
         a3tFCLGJTl7DgRKp7cDhl1Rr3OJzbHN49W/Ew=
MIME-Version: 1.0
In-Reply-To: <AANLkTikE1qnxHcLKax08cVOo_doeXzj5+42-Bt87FGCZ@mail.gmail.com>
References: <AANLkTimC5Vz7x9+MNJcewijoyw=Nyr6WWP=YR8cxqarH@mail.gmail.com>
	<alpine.DEB.2.00.1009130855430.26275@router.home>
	<4C8F0CF8.1050309@cs.helsinki.fi>
	<AANLkTikE1qnxHcLKax08cVOo_doeXzj5+42-Bt87FGCZ@mail.gmail.com>
Date: Mon, 20 Sep 2010 15:12:07 +0200
Message-ID: <AANLkTikmVz5oRL3hS66abnOsXa7Yu3=Atj0OyhT8enxL@mail.gmail.com>
Subject: Re: Regression on UP ARM from commit e18d65f0500b95d8724b17d8ea9f1116cf390bbe
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Christoph Lameter <cl@linux.com>,
        linux kernel <linux-kernel@vger.kernel.org>, tj@linux.com,
        =?ISO-8859-1?Q?Jonas_=C5berg?= <jonas.aberg@stericsson.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/20 Pekka Enberg <penberg@kernel.org>:

> Linus, care to retest linux-next on your configuration? The above
> commit has now been replaced with proper UP per-cpu allocator support
> by Tejun Heo.

For various administrative reasons I have lost contact with the hardware,
hang on and I'll retest as soon as I can!

Yours,
Linus Walleij
