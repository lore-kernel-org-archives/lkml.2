Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab1DYGci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 02:32:38 -0400
Received: from mail.perches.com ([173.55.12.10]:4954 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab1DYGci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 02:32:38 -0400
Subject: Re: Expanding checkpatch for non-linux (specifically U-Boot) use
From: Joe Perches <joe@perches.com>
To: Graeme Russ <graeme.russ@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        U-Boot Users <u-boot@lists.denx.de>
In-Reply-To: <4DB51333.7060809@gmail.com>
References: <4DB50854.8090700@gmail.com>
	 <1303711340.1745.30.camel@Joe-Laptop>  <4DB51333.7060809@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 23:32:36 -0700
Message-ID: <1303713156.1745.38.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 16:22 +1000, Graeme Russ wrote:
> I like this - And checkpatch.pl could set the default options for 'Linux
> flavour' so Linux would not need a .conf file :)
> 
> BUT - The question still remains - Will patches for obviously non-Linux
> related 'features' of checkpatch be welcomed and incorporated into checkpatch?

I don't see a problem with it, I'd ack patches if the
design and implementation is reasonably clean, but it's
not really for me to decide.

Another possibility is to keep all the uboot specific
stuff in a separate .pl file and let that file be
executed by checkpatch.  Modularity and such is good.

Andy Whitcroft is the nominal maintainer, but he hasn't
been particularly active with checkpatch for awhile as
his real job seems to keep him busy.

Andrew Morton has been overseeing most of the trivial
style maintenance patches to checkpatch for the last
year or so.

cheers, Joe

