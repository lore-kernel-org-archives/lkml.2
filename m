Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab2EGOsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:48:14 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37589 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757036Ab2EGOsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:48:10 -0400
X-Sasl-enc: nPgbGgtbuomNiKt1CYnpza1MRd9bc2Oi0m9YFuzSAHGC 1336402089
Date: Mon, 7 May 2012 07:48:07 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: linux-next: manual merge of the staging tree with the tty tree
Message-ID: <20120507144807.GA21302@kroah.com>
References: <20120507155831.a84a079857b24b7772333a37@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120507155831.a84a079857b24b7772333a37@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 03:58:31PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/serial/68360serial.c between commit d29f3ef39be4
> ("tty_lock: Localise the lock") from the tty tree and commit 60e6d2689c2a
> ("staging: evict abandoned 68360serial.c driver from the kernel") from
> the staging tree.
> 
> The latter removed the file, so I did that.

That sounds correct, thanks for doing it.

greg k-h
