Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab1HCO24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 10:28:56 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41541 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754071Ab1HCO2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 10:28:42 -0400
X-Sasl-enc: 2x4N6Nf6SXtfKfC/gP49wOlRN951MvOr18iZ3G7lZjbz 1312381721
Date: Wed, 3 Aug 2011 07:26:43 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-ID: <20110803142643.GB9756@kroah.com>
References: <20110803141641.00402b8e49dd68aa58c458ac@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110803141641.00402b8e49dd68aa58c458ac@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 02:16:41PM +1000, Stephen Rothwell wrote:
> Hi Paul,
> 
> After merging the moduleh tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/staging/zcache/zcache-main.c:57:16: error: expected declaration specifiers or '...' before string constant
> drivers/staging/zcache/zcache-main.c:57:1: warning: data definition has no type or storage class
> drivers/staging/zcache/zcache-main.c:57:1: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
> drivers/staging/zcache/zcache-main.c:57:16: warning: function declaration isn't a prototype
> 
> Caused by commit fd6b68bbac9f ("staging: zcache: module is GPL")
> interacting with the module.h split up.
> 
> Greg, this file needs module.h even in upstream.

Ick, sorry about that, now fixed.

greg k-h
