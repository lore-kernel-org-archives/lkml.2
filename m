Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab1GCQXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 12:23:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991Ab1GCQXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 12:23:51 -0400
Date: Sun, 3 Jul 2011 09:23:29 -0700
From: Greg KH <gregkh@suse.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2/7] debugfs: add debugfs_create_int
Message-ID: <20110703162329.GA28131@suse.de>
References: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
 <1309702581-16863-3-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309702581-16863-3-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 03, 2011 at 11:16:16PM +0900, Akinobu Mita wrote:
> Introduce debugfs_create_int() for creating a debugfs file that is used to
> read and write an int value.

Um, what's wrong with the existing s32 and s64 versions that debugfs
already provides?

userspace doesn't know what "int" means for the kernel as it might be
running in 32bit mode with a 64bit kernel.  That is why this isn't a
good idea, so please convert your other patch to use the existing api
and change the variable type in your patch.

greg k-h
