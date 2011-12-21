Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1LUGcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 01:32:41 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:59204 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750733Ab1LUGci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 01:32:38 -0500
Message-ID: <1324449156.21735.7.camel@joe2Laptop>
Subject: Re: [PATCH] vmalloc: remove #ifdef in function body
From: Joe Perches <joe@perches.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 20 Dec 2011 22:32:36 -0800
In-Reply-To: <op.v6ttagny3l0zgt@mpn-glaptop>
References: <1324444679-9247-1-git-send-email-minchan@kernel.org>
	 <1324445481.20505.7.camel@joe2Laptop>
	 <20111221054531.GB28505@barrios-laptop.redhat.com>
	 <1324447099.21340.6.camel@joe2Laptop> <op.v6ttagny3l0zgt@mpn-glaptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 07:21 +0100, Michal Nazarewicz wrote:
> it seems the community prefers
> having ifdefs outside of the function.

Some do, some don't.

http://comments.gmane.org/gmane.linux.network/214543

If it's not in coding style, I suggest
it should be changed if it doesn't
add some other useful value.

