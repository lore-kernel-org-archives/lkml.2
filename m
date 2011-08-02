Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab1HBSIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 14:08:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab1HBSIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 14:08:19 -0400
Date: Tue, 2 Aug 2011 21:05:37 +0300
From: Dan Carpenter <error27@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Use kstrdup rather than duplicating its implementation
Message-ID: <20110802180537.GB3839@shale.localdomain>
References: <1312302089.2629.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312302089.2629.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 06:21:26PM +0200, Thomas Meyer wrote:
>  The semantic patch that makes this output is available
>  in scripts/coccinelle/api/kstrdup.cocci.
> 
>  More information about semantic patching is available at
>  http://coccinelle.lip6.fr/
> 

These should be sent individually, because the chunks need to go into
a bunch of separate trees before they get merged into the official
kernel.  (One change per file basically on this).

regards,
dan carpenter

