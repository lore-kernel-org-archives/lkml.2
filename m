Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638Ab2EKO7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:59:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41246 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233Ab2EKO7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:59:00 -0400
Date: Fri, 11 May 2012 07:58:56 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Staging: ipack: move the devices source line in
 Kconfig file
Message-ID: <20120511145856.GG5958@kroah.com>
References: <1336724236-21665-1-git-send-email-siglesias@igalia.com>
 <1336724236-21665-2-git-send-email-siglesias@igalia.com>
 <4FACF22C.1050304@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FACF22C.1050304@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 12:04:12PM +0100, Martyn Welch wrote:
> On 11/05/12 09:17, Samuel Iglesias Gonsalvez wrote:
> > Maintain the proper order of definitions in Kconfig following the time order of
> > the commits.
> > 
> 
> This could probably be rolled up into patch 1.

It could, but this is fine, they do two different things.

thanks,

greg k-h
