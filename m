Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab2FMOMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:12:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44477 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab2FMOMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:12:02 -0400
Date: Wed, 13 Jun 2012 07:11:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Aurelien Gerault <aurelien.gerault-xsig@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        Aurelien Gerault <aurelien.gerault-nonst@stericsson.com>
Subject: Re: [PATCH] printk: Ensure oops printing if console is locked
Message-ID: <20120613141157.GB11538@kroah.com>
References: <1339578852-17617-1-git-send-email-aurelien.gerault-xsig@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339578852-17617-1-git-send-email-aurelien.gerault-xsig@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 11:14:12AM +0200, Aurelien Gerault wrote:
> From: Aurelien Gerault <aurelien.gerault-nonst@stericsson.com>
> 
> Ensuring that oops & panic messages/backtraces will be printed
> in console, even when the console is locked.
> 
> If console is locked by someone else but an oops is ongoing, force
> unlocking / re-locking to display the oops.
> 
> Signed-off-by: Aurelien Gerault <aurelien.gerault-nonst@stericsson.com>
> ST-Ericsson Linux next: NA
> ST-Ericsson ID: 436456
> ST-Ericsson FOSS-OUT ID: Trivial

What are those fields for?

> Change-Id: I9f571492fefc32291ecd0cc62f0ad7031cab7c6d

What is this for?

Please clean up the patch before sending it out publicly, we can't take
stuff like this...

