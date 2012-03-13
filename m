Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966Ab2CMVuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:50:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56930 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759923Ab2CMVul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:50:41 -0400
Date: Tue, 13 Mar 2012 14:50:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Subject: Re: [PATCH 0000/0004] drivers: hv
Message-ID: <20120313215036.GA4972@kroah.com>
References: <1331422300-4330-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331422300-4330-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 03:31:40PM -0800, K. Y. Srinivasan wrote:
> 
> This patch-set further enhances the KVP functionality for Linux
> guests:
> 
> 	1. Supports most of the Win8 KVP protocol.
> 	2. Supports operations on all the pools.

I've only applied the first patch, due to the issues with the second.
Feel free to resend the rest when you have them worked out.

greg k-h
