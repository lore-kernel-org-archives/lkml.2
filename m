Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0DWIOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:14:07 -0400
Received: from bamako.nerim.net ([62.4.17.28]:60502 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab0DWIOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:14:01 -0400
Date: Fri, 23 Apr 2010 10:13:56 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Farid Hammane <farid.hammane@gmail.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, ben-linux@fluff.org,
       Enrik.Berkhan@ge.com, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-algo-pca: fix all coding style issues in
 i2c-algo-pca.c
Message-ID: <20100423101356.454abdd6@hyperion.delvare>
In-Reply-To: <201004222330.34660.farid.hammane@gmail.com>
References: <1271877097-10939-1-git-send-email-farid.hammane@gmail.com>
	<20100422092524.77b7aa84@hyperion.delvare>
	<20100422075937.GN24384@pengutronix.de>
	<201004222330.34660.farid.hammane@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Farid,

On Thu, 22 Apr 2010 23:30:34 +0200, Farid Hammane wrote:
> Hi Jean and Wolfram,
> 
> On Thursday 22 April 2010 09:59:37 you wrote:
> > On Thu, Apr 22, 2010 at 09:25:24AM +0200, Jean Delvare wrote:
> > > On Thu, 22 Apr 2010 01:57:38 +0200, Wolfram Sang wrote:
> > > > Hi Farid,
> > > >
> > > > thanks for this approach. Have you checked that the binary is the same
> > > > before/after your patch? If so, please mention in your patch
> > > > description.
> 
> Ok, I think that nothing can be broken with this kind of patch. I just built 
> i2c-algo-pca.c and everything was ok.
> 
> For further patchs I will mention that it has been tested. Thanks for the 
> advice !

It's not just a matter of building it. When you only fix coding style
issue, the binary object before and after your patch should be exactly
the same. It's a good idea to verify this, especially for drivers you
aren't using yourself.

-- 
Jean Delvare
