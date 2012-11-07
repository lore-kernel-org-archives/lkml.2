Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab2KGTmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 14:42:15 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40644 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab2KGTmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 14:42:14 -0500
Date: Wed, 07 Nov 2012 14:42:12 -0500 (EST)
Message-Id: <20121107.144212.1481427869140100342.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: lee.jones@linaro.org, linux-kernel@vger.kernel.org, isdn@linux-pingi.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] isdn: Make CONFIG_ISDN depend on CONFIG_NETDEVICES
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121107150436.3d25ee51@pyramind.ukuu.org.uk>
References: <1352282103-13665-1-git-send-email-lee.jones@linaro.org>
	<20121107150436.3d25ee51@pyramind.ukuu.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Wed, 7 Nov 2012 15:04:36 +0000

> On Wed,  7 Nov 2012 10:55:03 +0100
> Lee Jones <lee.jones@linaro.org> wrote:
> 
>> It doesn't make much sense to enable ISDN services if you don't
>> intend to connect to a network. 
> 
> I would disagree. However what I don't understand and you've not
> explained is why the current code is a bug or a problem ?
> 
> This seems to be a make-work inconvenience causing patch that serves no
> useful purpose ?

The ISDN drivers are peppered with CONFIG_NETDEVICES protection,
but there are missing cases in several locations.

This is ugly, and causes build problems, so adding the dependency
is the cleanest and most correct soluation and I fully intend
to apply this patch.
