Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab1AaVkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:40:19 -0500
Received: from kroah.org ([198.145.64.141]:54199 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487Ab1AaVkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:40:15 -0500
Date: Mon, 31 Jan 2011 13:37:03 -0800
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 04/20] staging/cx25721: serialize access to devlist
Message-ID: <20110131213703.GA10438@kroah.com>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
 <1295993854-4971-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295993854-4971-5-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 11:17:18PM +0100, Arnd Bergmann wrote:
> Out of the three files accessing the device list,
> one uses a mutex, one uses the BKL and one does
> not have any locking. That is of course pointless,
> so let's make all of them use the same mutex,
> and get rid of one more BKL user.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>

Mauro, you will take this one, right?  If so, please add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to it.

If not, please let me know and I will take it myself.

thanks,

greg k-h
