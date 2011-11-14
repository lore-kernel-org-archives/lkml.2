Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab1KNBIa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 20:08:30 -0500
Received: from mail.vyatta.com ([76.74.103.46]:37036 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab1KNBI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 20:08:28 -0500
Date: Sun, 13 Nov 2011 17:08:25 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Joe Perches <joe@perches.com>
Cc: Arend van Spriel <arend@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmsmac: Use current logging styles
Message-ID: <20111113170825.6633b17e@nehalam.linuxnetplumber.net>
In-Reply-To: <1321213264.15834.4.camel@Joe-Laptop>
References: <1321213264.15834.4.camel@Joe-Laptop>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Nov 2011 11:41:04 -0800
Joe Perches <joe@perches.com> wrote:

> Add and use pr_fmt and pr_<level>
> Remove useless double parentheses from macros.
> Remove function names from format strings, add to pr_debug use.
> Coalesce formats.
> Remove uncompileable undeclared variable in a DMA_NONE use.

If you are going to change it why not got all the way to netdev_XXX and dev_XXX macros
instead.
