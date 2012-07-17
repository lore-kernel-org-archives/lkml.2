Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2GQGYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 02:24:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46743 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2GQGYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 02:24:51 -0400
Date: Mon, 16 Jul 2012 23:24:48 -0700 (PDT)
Message-Id: <20120716.232448.2148675554738101630.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: tilman@imap.cc, hjlipp@web.de, isdn@linux-pingi.de,
        gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gigaset: silence GCC warning for unused 'format_ie'
From: David Miller <davem@davemloft.net>
In-Reply-To: <1342343515.1780.2.camel@x61.thuisdomein>
References: <1342343515.1780.2.camel@x61.thuisdomein>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Sun, 15 Jul 2012 11:11:55 +0200

> Building Gigaset's CAPI support without Gigaset's debugging enabled
> triggers this GCC warning:
>     'format_ie' defined but not used [-Wunused-function]
> 
> Silence this warning by wrapping format_ie() in an "#ifdef
> CONFIG_GIGASET_DEBUG" and "#endif" pair.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied.
