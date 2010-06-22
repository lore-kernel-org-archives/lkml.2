Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373Ab0FVIou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 04:44:50 -0400
Received: from norkia.v3.sk ([91.210.183.14]:47007 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab0FVIot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 04:44:49 -0400
X-Greylist: delayed 1081 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jun 2010 04:44:49 EDT
Subject: Re: [PATCH] [fs/sysv] Fix NULL deref. when allocating new inode
From: Lubomir Rintel <lkundrak@v3.sk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20100621154046.b5e8319c.akpm@linux-foundation.org>
References: <1277039843-32548-1-git-send-email-lkundrak@v3.sk>
	 <20100621154046.b5e8319c.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jun 2010 10:26:36 +0200
Message-ID: <1277195196.27623.155.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.91 (2.29.91-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 15:40 -0700, Andrew Morton wrote:
> On Sun, 20 Jun 2010 15:17:23 +0200
> Lubomir Rintel <lkundrak@v3.sk> wrote:
> 
> > A call to sysv_write_inode() in sysv_new_inode() to its new interface
> > that replaced wait flag with writeback structure. This was broken by
> > a9185b41a4f84971b930c519f0c63bd450c4810d.

> hm.  AFACIT this means that 2.6.34's sysvfs will instantaneously oops,
> every time.

Ah yes, really. I thought I checked that and found that only 2.6.35 was
affected which is why did not cc stable@. git tag --contains proves me
wrong though, sorry for that.

-- 
Flash is the Web2.0 version of blink and animated gifs.
                                     -- Stephen Smoogen

