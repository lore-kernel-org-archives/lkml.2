Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab2LSPyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:54:13 -0500
Received: from xes-mad.com ([216.165.139.218]:21686 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab2LSPyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:54:05 -0500
Message-ID: <1355932316.21821.31.camel@petert>
Subject: Re: [PATCH] gpio-ich: Add missing spinlock init
From: Peter Tyser <ptyser@xes-inc.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 19 Dec 2012 09:51:56 -0600
In-Reply-To: <20121216213140.22954434@endymion.delvare>
References: <20121216213140.22954434@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-12-16 at 21:31 +0100, Jean Delvare wrote:
> As reported by CONFIG_DEBUG_SPINLOCK=y.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Peter Tyser <ptyser@xes-inc.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: stable@vger.kernel.org [v3.5+]
> ---

Acked-by: Peter Tyser <ptyser@xes-inc.com>

