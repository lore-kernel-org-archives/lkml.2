Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab2HNB6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 21:58:37 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33264 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab2HNB6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 21:58:35 -0400
Date: Mon, 13 Aug 2012 18:58:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Devendra Naga <develkernel412222@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mikko =?iso-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
        Lauri Hintsala <Lauri.Hintsala@bluegiga.com>,
        Riku =?iso-8859-1?Q?Mett=E4l=E4?= <riku.mettala@bluegiga.com>,
        Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Subject: Re: [PATCH 0/5] staging/csr: cleanup patches
Message-ID: <20120814015828.GA26723@kroah.com>
References: <1344064508-11975-1-git-send-email-develkernel412222@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344064508-11975-1-git-send-email-develkernel412222@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 01:00:08PM +0545, Devendra Naga wrote:
> Actually i have a question about the dbg macros, unifi_warning,
> unifi_error, and unifi_trace,
> 
> I think these can be implemented using dev_warn, dev_dbg, functions,
> i mean we can remove these unifi_warning and unifi_error and unifi_trace
> and use the dev_warn and dev_dbg.

Yes, we should use those instead.

thanks,

greg k-h
