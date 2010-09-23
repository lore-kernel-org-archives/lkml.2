Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab0IWTmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:42:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45425 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab0IWTmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:42:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=YIKZhg5wsAXEY2PBTNQn+Pffg3wM8S1ttUeVTMfW49RPzF+ce78ih9J6/NURbVjANQ
         LqCLu6axQNW9Tiw3ijDbjoGXr2e6MS4DgxFd1riScEP5ilpJSfEhvo9SQ8R8Q/fmjKVp
         BGpMuPCXztdWdBfPfIhSwM19AqSqaJs2mrcl4=
MIME-Version: 1.0
In-Reply-To: <20100920130119.GA23406@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de>
	<1281956870-12463-2-git-send-email-s.hauer@pengutronix.de>
	<20100920130119.GA23406@pengutronix.de>
Date: Thu, 23 Sep 2010 12:42:20 -0700
X-Google-Sender-Auth: bTY0_mHuob0wCCTIok2D7zqMAg4
Message-ID: <AANLkTi=B1ZkoYZ3hjuzz8Uj=W-04cE+iedaMwurUMRPy@mail.gmail.com>
Subject: Re: [PATCH 1/3] dmaengine: add possibility for cyclic transfers
From: Dan Williams <dan.j.williams@intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 6:01 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> Hi Dan,
>
> Any comment to this patch?

Looks good to me especially given the unique implications for
callbacks.  Although, I'd like to put a description of the
prep_dma_cyclic semantics in the source code.  Can you respin this
with a description added to the kernel-doc for struct dma_device?

--
Dan
