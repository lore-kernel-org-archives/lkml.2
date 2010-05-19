Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0ESQfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:35:00 -0400
Received: from kroah.org ([198.145.64.141]:46325 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab0ESQet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:34:49 -0400
Date: Wed, 19 May 2010 09:33:34 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Several improvements to USB gadgets
Message-ID: <20100519163334.GA20853@kroah.com>
References: <cover.1274187425.git.m.nazarewicz@samsung.com>
 <op.vcx37f0i7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vcx37f0i7p4s8u@pikus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 11:19:53AM +0200, Michał Nazarewicz wrote:
> On Wed, 19 May 2010 11:04:13 +0200, Michal Nazarewicz <m.nazarewicz@samsung.com> wrote:
> > This patchset introduces several improvements to USB gadget,
> > functions, etc.:
> 
> Uh, damn, sorry for posting those twice.  I did a:
> 
>    git send-email * --to linux-usb@vger.kernel.org 000*
> 
> ie. given all files as arguments twice.

Please always cc: the usb subsystem maintainer if you wish to have the
patches applied.  Otherwise they can easily be missed...

thanks,

greg k-h
