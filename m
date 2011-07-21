Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1GUKC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:02:56 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47392 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab1GUKCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:02:55 -0400
Date: Thu, 21 Jul 2011 18:01:50 +0800
From: wangyanqing <udknight@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]drivers:net:Kconfig
Message-ID: <20110721100150.GA2902@udknight.homenetwork>
References: <20110719090014.GA5455@udknight>
 <20110719113706.GA18436@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110719113706.GA18436@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 04:37:06AM -0700, Greg KH wrote:
> On Tue, Jul 19, 2011 at 05:00:14PM +0800, wangyanqing wrote:
> >  Broadcom Tigon3 driver tg3.ko can't work without the Broadcom PHY,
> >  so maybe we should add a dependence on it.Or at least we should add
> >  notice in the help txt.
> > 
> > Signed-off-by: wang yanqing <udknight@gmail.com>
> > ---
> >  drivers/net/Kconfig |    2 +-
> 
> Ok, but why in the world would you send this patch to me?
> 
> confused,
> 
> greg k-h
HOHO,I just haven't learn how to use the scripts/get_maintainer.pl, but now I know how to use it. 
Sorry, man, but you can treat it as a joke!
