Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab0KDR0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 13:26:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41583 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab0KDR0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 13:26:22 -0400
Date: Thu, 4 Nov 2010 13:26:13 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, werner@suse.de,
        alan@lxorguk.ukuu.org.uk, gregkh@suse.de, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Kyle McMartin <kyle@mcmartin.ca>,
        Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH v2 2/5] parisc: cleanup console handling
Message-ID: <20101104172613.GK8332@bombadil.infradead.org>
References: <1288884024-23873-1-git-send-email-jslaby@suse.cz>
 <1288884024-23873-2-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288884024-23873-2-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 04:20:21PM +0100, Jiri Slaby wrote:
> * use newly added for_each_console for iterating consoles
> * add proper console locking
> * do not initialize tmp twice
> * no need to declare console_drivers, it's already done in console.h
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Kyle McMartin <kyle@mcmartin.ca>
> Cc: Helge Deller <deller@gmx.de>
> Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
> Cc: linux-parisc@vger.kernel.org

This looks fine...
Acked-by: Kyle McMartin <kyle@mcmartin.ca>

I assume that since it depends on 1/5 you'd prefer to merge it with the
rest?

--Kyle
