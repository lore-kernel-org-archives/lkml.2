Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab2HVLtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 07:49:25 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62995 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab2HVLtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 07:49:23 -0400
MIME-Version: 1.0
In-Reply-To: <1345624986-5557-1-git-send-email-linus.walleij@stericsson.com>
References: <1345624986-5557-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 22 Aug 2012 13:49:22 +0200
Message-ID: <CACRpkdYyrFZYuNSj+y7f1uyF53+TYqdSfEcpv28H677uS1fd6A@mail.gmail.com>
Subject: Re: [PATCH 0/7] Ux500 and MASK_ON_SUSPEND
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Etienne Carriere <etienne.carriere@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 10:43 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> We have discovered transient IRQs when going to suspend on the
> Ux500 platform. This patch series hits all sources by marking
> the applicable IRQchips with MASK_ON_SUSPEND.
>
> I don't know if this is a common problem or seen in other
> platforms so comments are welcome.
>
> Else I request that the patches be merged into respective
> subtree, I will take care of the ux500, gpio and pinctrl
> patches myself, while Sam gets to merge all the MFD stuff.

Bah it turns out transient IRQs are only occurring on the pinctrl
and maybe GIC. Let's just flag these two, forget the rest of the
patches.

Yours,
Linus Walleij
