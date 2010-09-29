Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab0I2Fj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 01:39:59 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:52996 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab0I2Fj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 01:39:57 -0400
Date: Wed, 29 Sep 2010 07:39:56 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] altera_uart: Add support for getting mapbase and
	IRQ from resources
Message-ID: <20100929053956.GF3137@distanz.ch>
References: <20100928133531.GC8289@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100928133531.GC8289@oksana.dev.rtsoft.ru>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-28 at 15:35:31 +0200, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> This makes it much easier to integrate the driver with the rest of
> the Linux (e.g. MFD subsystem).
> 
> The old method is still supported though.
> 
> Also, from now on, there is one platform device per port (no
> changes are needed for the platform code, as no one registers
> the devices anywhere in-tree yet).
> 
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

Looks good to me.

Acked-by: Tobias Klauser <tklauser@distanz.ch>
