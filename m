Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab2IZUy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 16:54:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46470 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab2IZUyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 16:54:25 -0400
Date: Wed, 26 Sep 2012 13:54:20 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Alan Cox <alan@linux.intel.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [PATCH v9 0/11] KGDB/KDB FIQ (NMI) debugger
Message-ID: <20120926205420.GA2510@kroah.com>
References: <20120924212648.GA27605@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924212648.GA27605@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 02:26:50PM -0700, Anton Vorontsov wrote:
> Hi all,
> 
> Here comes v9...
> 
> Greg, patches 1-7 have gotten all the needed acks from Alan and Jason, so
> it would be awesome if you could apply them to your tty-next tree.

All 7 patches of these are now applied, thanks.

greg k-h
