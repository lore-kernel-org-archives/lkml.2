Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1DYVWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 17:22:37 -0400
Received: from kroah.org ([198.145.64.141]:51618 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab1DYVWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 17:22:36 -0400
Date: Mon, 25 Apr 2011 14:20:56 -0700
From: Greg KH <greg@kroah.com>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 08/11] tty: add pruss SUART driver
Message-ID: <20110425212056.GA29313@kroah.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
 <1303474109-6212-9-git-send-email-subhasish@mistralsolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303474109-6212-9-git-send-email-subhasish@mistralsolutions.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 05:38:26PM +0530, Subhasish Ghosh wrote:
> This patch adds support for the TTY compliant
> Soft-UART device emulated on PRUSS.
> 
> This patch depends on:
> davinci: macro rename DA8XX_LPSC0_DMAX to DA8XX_LPSC0_PRUSS.
>             https://patchwork.kernel.org/patch/615681/
> davinci: changed SRAM allocator to shared ram.
>             https://patchwork.kernel.org/patch/549351/

Who is going to be applying these patches to the tree?

Should this driver go through a davinci subtree because of these
dependancies?

thanks,

greg k-h
