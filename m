Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934884Ab0KQQDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:03:55 -0500
Received: from cantor.suse.de ([195.135.220.2]:42954 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758125Ab0KQQDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:03:54 -0500
Date: Wed, 17 Nov 2010 08:03:20 -0800
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Nathan Laredo <laredo@gnu.org>
Subject: Re: [PATCH 1/7] staging/stradis: mark as "depends on BKL"
Message-ID: <20101117160320.GA10216@suse.de>
References: <1290007619-5787-1-git-send-email-arnd@arndb.de>
 <1290007619-5787-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290007619-5787-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 04:26:53PM +0100, Arnd Bergmann wrote:
> The stradis driver is on its way out, but it
> should still be marked correctly as depending
> on the big kernel lock. It could easily be
> changed to not require it if someone decides
> to revive the driver and port it to v4l2 in
> the process.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Sedat Dilek <sedat.dilek@googlemail.com>
> Cc: Nathan Laredo <laredo@gnu.org>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
