Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab2FKHkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 03:40:08 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:53579 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750795Ab2FKHkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 03:40:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAIKg1U9bdWOb/2dsb2JhbABFhVevAIEHghgBAQUjVhALGAICJgICVwaIIqU9kX6BI4oEhFeBEgOacYNQhliCYg
X-IronPort-AV: E=Sophos;i="4.77,387,1336341600"; 
   d="scan'208";a="1001645199"
Message-ID: <1339400404.3963.7.camel@fourier.local.igalia.com>
Subject: Re: [PATCH] Staging: ipack: remove pr_fmt definition.
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 11 Jun 2012 09:40:04 +0200
In-Reply-To: <20120611072736.GI13539@mwanda>
References: <1339397797-17399-1-git-send-email-siglesias@igalia.com>
	 <20120611072500.GT4400@mwanda> <20120611072736.GI13539@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 10:27 +0300, Dan Carpenter wrote:
> On Mon, Jun 11, 2012 at 10:25:00AM +0300, Dan Carpenter wrote:
> > On Mon, Jun 11, 2012 at 08:56:36AM +0200, Samuel Iglesias Gonsalvez wrote:
> > > As there is no pr_* function used here, pr_fmt is not needed.
> > > 
> > 
> > Nah.  What about if we decide to add some?  Also there are actually
> > a couple pr_err() calls in there already.
> 
> Oops.  Sorry my tree is old.  We removed the two calls to pr_err().

Same mistake here. In greg's staging-next the pr_err calls are not
present so the patch is totally valid but in linus branch they are there
(this is the reason of my error).

So, this patch is valid, unless we want the pr_fmt definition for the
future. However, I prefer to delete it.

Cheers,

Sam

