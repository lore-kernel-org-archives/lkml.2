Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab0LTVty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:49:54 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48537 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab0LTVtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:49:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dWg1k5OnvCiumZMxddszRTm+iBnLQRJnr7AZne6ursgUYG3NBKfwrGpqMu5zp5dQmS
         jfEGiUZOU39YZ2pPCF1LFZukkzrZ9fA+pb1CBA3z3fyeav2BYOkowNXFiaLDj6bjNJdK
         JFmvmW1MaCB9kyFFsoxVw+1U3w+MtuZqFER5g=
MIME-Version: 1.0
In-Reply-To: <1292875718-7980-2-git-send-email-sboyd@codeaurora.org>
References: <1292649385-28771-1-git-send-email-sboyd@codeaurora.org>
	<1292875718-7980-1-git-send-email-sboyd@codeaurora.org>
	<1292875718-7980-2-git-send-email-sboyd@codeaurora.org>
Date: Mon, 20 Dec 2010 16:49:52 -0500
Message-ID: <AANLkTi=8F3keaAQ2o+V8gNncNM02c9k9=DRtd5GyP_LH@mail.gmail.com>
Subject: Re: [PATCH 1/3] hvc_dcc: Fix bad code generation by marking assembly volatile
From: Arnaud Lacombe <lacombar@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Daniel Walker <dwalker@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 20, 2010 at 3:08 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> Without marking the asm __dcc_getstatus() volatile my compiler
> decides [...]
What compiler ? That might be a usefull information to know,
espectially 5 years from now when tracing code history. There has been
similar issue with gcc 4.5 recently. AFAIK, in the same idea, the
final change has been to mark the asm volatile.

Thanks,
 - Arnaud
