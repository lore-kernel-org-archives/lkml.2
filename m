Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab1LSUsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:48:22 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:45726 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab1LSUsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:48:18 -0500
Date: Mon, 19 Dec 2011 16:47:57 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        linux-next@vger.kernel.org
Subject: Re: [Xen-devel] linux-next: Tree for Dec 19 (xen)
Message-ID: <20111219204757.GB29852@andromeda.dapyr.net>
References: <20111219185556.f07c1f43e28cfd594aaa5fe0@canb.auug.org.au> <4EEF9F44.8080707@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEF9F44.8080707@xenotime.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 12:32:04PM -0800, Randy Dunlap wrote:
> On 12/18/2011 11:55 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20111216:
> 
> 
> drivers/xen/xenbus/xenbus_dev_frontend.c: In function 'xenbus_init':
> drivers/xen/xenbus/xenbus_dev_frontend.c:609:2: error: implicit declaration of function 'xen_domain'
> 
> Full randconfig file is attached.

Fixed. Thx!
