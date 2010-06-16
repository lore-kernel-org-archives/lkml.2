Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab0FPVBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 17:01:50 -0400
Received: from kroah.org ([198.145.64.141]:35303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932525Ab0FPVBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 17:01:49 -0400
Date: Wed, 16 Jun 2010 13:49:06 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 00/31] tty: BKL removal
Message-ID: <20100616204906.GA15837@kroah.com>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275425591-8803-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 10:52:40PM +0200, Arnd Bergmann wrote:
> Hi Greg,
> 
> As promised, here is a resend of the patches from
> both Alan and myself, making the BKL optional
> in the TTY layer. Please apply to your tty-next
> tree.

All applied now, thanks for doing this work.

let's see what breaks now :)

thanks,

greg k-h
