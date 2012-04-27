Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761099Ab2D0SZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:25:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34487 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760485Ab2D0SZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:25:52 -0400
X-Sasl-enc: qQnTu6ToQER59PPH/q2gdGk5JlcMZQ/+p5WeAYyUnpzE 1335551151
Date: Fri, 27 Apr 2012 11:25:31 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the usb tree
Message-ID: <20120427182531.GA10970@kroah.com>
References: <20120427141234.242d7f7abb4b5453255d7544@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427141234.242d7f7abb4b5453255d7544@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 02:12:34PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the usb tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from drivers/usb/host/ohci-hcd.c:1079:0:
> drivers/usb/host/ohci-ps3.c: In function 'ps3_ohci_hc_start':
> drivers/usb/host/ohci-ps3.c:48:3: error: implicit declaration of function 'err' [-Werror=implicit-function-declaration]
> 
> Caused by commit af4e1ee04026 ("USB: remove err() macro").

Ick, sorry about that, I missed some of the ohci controller drivers,
they should all now be fixed up.

greg k-h
