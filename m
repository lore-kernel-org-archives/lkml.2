Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1KNBKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 20:10:32 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:41733 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751071Ab1KNBKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 20:10:31 -0500
Message-ID: <1321233030.15834.12.camel@Joe-Laptop>
Subject: Re: [PATCH] brcmsmac: Use current logging styles
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Arend van Spriel <arend@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Sun, 13 Nov 2011 17:10:30 -0800
In-Reply-To: <20111113170825.6633b17e@nehalam.linuxnetplumber.net>
References: <1321213264.15834.4.camel@Joe-Laptop>
	 <20111113170825.6633b17e@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-13 at 17:08 -0800, Stephen Hemminger wrote:
> On Sun, 13 Nov 2011 11:41:04 -0800
> Joe Perches <joe@perches.com> wrote:
> 
> > Add and use pr_fmt and pr_<level>
> > Remove useless double parentheses from macros.
> > Remove function names from format strings, add to pr_debug use.
> > Coalesce formats.
> > Remove uncompileable undeclared variable in a DMA_NONE use.
> 
> If you are going to change it why not got all the way to netdev_XXX and dev_XXX macros
> instead.

No dev always available, simpler change,
mirrors the changes in brcmfmac.

