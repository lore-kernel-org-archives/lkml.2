Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab2KVSdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:33:04 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38887 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2KVSdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:00 -0500
Date: Wed, 21 Nov 2012 15:18:46 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/58] tty: Mark sysfs_attr_ns static
Message-ID: <20121121231846.GA14770@kroah.com>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
 <1353302917-13995-12-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353302917-13995-12-git-send-email-josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 09:27:50PM -0800, Josh Triplett wrote:
> Nothing outside of fs/sysfs/file.c references this function, so mark it static.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  fs/sysfs/file.c |    4 ++--

Your Subject: is a bit wrong, this isn't a tty patch :(

I'll go clean it up...

