Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1AUWyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 17:54:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45062
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354Ab1AUWyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 17:54:53 -0500
Date: Fri, 21 Jan 2011 14:55:27 -0800 (PST)
Message-Id: <20110121.145527.219749753.davem@davemloft.net>
To: sam@ravnborg.org
Cc: sparclinux@vger.kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] sparc64: drop deprecated irq features
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110121222451.GA29468@merkur.ravnborg.org>
References: <20110121222451.GA29468@merkur.ravnborg.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 21 Jan 2011 23:24:51 +0100

> Sam Ravnborg (5):
>       sparc64: fix direct access to irq_desc
>       sparc: in handler_irq() rename irq parameter to pil
>       sparc64: all pointers to irq_handler_data renamed to handler_data
>       sparc64: use {get,set}_irq_data for handler_data
>       sparc64: use up-to-data genirq functions

I did a sanity build and boot of these changes against Linus current
tree and it seems to work fine on my Niagara-2+ machine.
