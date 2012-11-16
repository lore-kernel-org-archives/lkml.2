Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2KPTB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:01:56 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:48421 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752902Ab2KPTBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:01:55 -0500
Message-ID: <1353092514.2512.4.camel@joe-AO722>
Subject: Re: [PATCH] ipack: move header files to include/linux
From: Joe Perches <joe@perches.com>
To: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net, jens.taprogge@taprogge.org
Date: Fri, 16 Nov 2012 11:01:54 -0800
In-Reply-To: <1353089655.4563.56.camel@fourier.local.igalia.com>
References: <1353087276-4861-1-git-send-email-siglesias@igalia.com>
	 <1353089331.2512.2.camel@joe-AO722>
	 <1353089655.4563.56.camel@fourier.local.igalia.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 19:14 +0100, Samuel Iglesias Gonsálvez wrote:
> On Fri, 2012-11-16 at 10:08 -0800, Joe Perches wrote:
> > On Fri, 2012-11-16 at 18:34 +0100, Samuel Iglesias Gonsalvez wrote:
> > > Move ipack header files to include/linux/ directory where they belong to.
> > 
> > Why do these belong in include/linux?
> 
> They are used for other drivers that could be in other directories.

But are not currently.

> > What's wrong with path relative includes?
> 
> There is nothing wrong with relative includes. It's just to do the
> things as other subsystems do: keeping the bus' header file in
> include/linux directory.
> 
> Is this approach wrong for this case?

There's enough clutter in include/linux, so until these
includes are used by other directory drivers, I think so,
yes.  

cheers, Joe



