Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab1FGVfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:35:10 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43039 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932159Ab1FGVfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:35:08 -0400
X-Sasl-enc: XlJj0VzZBaNjWB1VTtnWHtBjFYbyi48RyWBdtkgOYAU7 1307482506
Date: Tue, 7 Jun 2011 14:31:12 -0700
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Endre Kollar <taxy443@gmail.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbip: change match_busid() to local function
Message-ID: <20110607213112.GA11067@kroah.com>
References: <4DE3F983.5050309@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DE3F983.5050309@freemail.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 10:09:39PM +0200, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The function match_busid() is only referenced in the stub_main.c so it can be changed
> to static. This will remove the following warning when compiling with "make W=1 ...":
> 
>  * drivers/staging/usbip/stub_main.c:40: warning: no previous prototype for ‘match_busid’
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>

This no longer applies, care to redo it against the next linux-next tree
that comes out?

thanks,

greg k-h
