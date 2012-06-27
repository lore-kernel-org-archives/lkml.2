Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab2F0CZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 22:25:27 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39936 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159Ab2F0CZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 22:25:25 -0400
X-Sasl-enc: CWP7V1FzwkZYwNHfzOWA0AFICFCHDj4tIetNapDDh6kN 1340763924
Date: Tue, 26 Jun 2012 19:25:23 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 04/12] gpio-sch: Fix resource leak
Message-ID: <20120627022523.GA3380@kroah.com>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
 <20120622154040.1405.28472.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622154040.1405.28472.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 04:42:40PM +0100, Alan Cox wrote:
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/gpio/gpio-sch.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Is this a serial driver?  I can't take this :(

greg k-h
