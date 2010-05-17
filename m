Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab0EQXuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:50:32 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64769 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab0EQXua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:50:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=xfruKRiIYsRuAuyia0BN3AbN4XbY9trb1Uf9jVHuNO2b7o++TlAF0gD+hW4RSCZldl
         PUup8IsD2hIG3Dn7EhZIamXcjw6IVvvpbG+PbLpY5Cc2Y7HvD8r7eti9wlveovDnzvHH
         MtCqRG8p9JDHRnD/zMrv8w58YhXpSngtxhEQ4=
MIME-Version: 1.0
In-Reply-To: <1274136092-12375-1-git-send-email-linus.walleij@stericsson.com>
References: <1274136092-12375-1-git-send-email-linus.walleij@stericsson.com>
Date: Mon, 17 May 2010 16:50:30 -0700
X-Google-Sender-Auth: i7ZiHqsfNsJBze4pa4EAWKSzBAo
Message-ID: <AANLkTinUgXVhhdWqb0tOCgQC6ai2LoDSkezehIIvX8W9@mail.gmail.com>
Subject: Re: [PATCH 3/3] DMAENGINE: extend the control command to include an 
	arg
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 3:41 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This adds an argument to the DMAengine control function, so that
> we can later provide control commands that need some external data
> passed in through an argument akin to the ioctl() operation
> prototype.
>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>

This one required some fixups, but I have made those and pushed the
result out async_tx.git/next along with the other two.

Thanks,
Dan
