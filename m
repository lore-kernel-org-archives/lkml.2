Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab2ATXLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 18:11:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab2ATXLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 18:11:50 -0500
Date: Fri, 20 Jan 2012 15:11:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] xen-blkfront: use bitmap_set() and bitmap_clear()
Message-Id: <20120120151149.04352aac.akpm@linux-foundation.org>
In-Reply-To: <20120120160938.GC3959@phenom.dumpdata.com>
References: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
	<1327072528-8479-4-git-send-email-akinobu.mita@gmail.com>
	<20120120152819.GA3959@phenom.dumpdata.com>
	<CAC5umyi9vuOh9Bx_HoB8ieXcVjZsisKOG6mCEM2ZGL7zXCrVTQ@mail.gmail.com>
	<20120120160938.GC3959@phenom.dumpdata.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jan 2012 11:09:38 -0500
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> > 
> > > Did you test this patch with a large amount of minors?
> > 
> > Sorry I didn't do runtime test.
> 
> Please do.

The poor guy probably doesn't know how to test it and surely it would
be quite a lot of work for him to do so.

Overall, it would be much more efficient if the tester of this code is
someone who is set up to easily apply the patch and test it.  ie: the
code maintainer(s).

