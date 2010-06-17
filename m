Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760539Ab0FQRwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:52:46 -0400
Received: from kroah.org ([198.145.64.141]:48809 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760388Ab0FQRwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:52:44 -0400
Date: Thu, 17 Jun 2010 10:46:17 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/6] USB: BKL removal
Message-ID: <20100617174617.GC3644@kroah.com>
References: <1275426285-9088-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275426285-9088-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 11:04:39PM +0200, Arnd Bergmann wrote:
> Hi Greg,
> 
> Here goes another series of BKL removal patches, mostly
> from Andi. There are some minor drivers left in the
> USB subsystem that someone should take care of, but
> this series at least gets to the point where USB
> works with the BKL disabled.
> 
> Please apply to your USB next tree.

All applied now, thanks so much for this work.

greg k-h
