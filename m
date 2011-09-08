Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab1IIAsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 20:48:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36977 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab1IIAsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 20:48:00 -0400
Date: Thu, 8 Sep 2011 09:23:04 -0700
From: Seth Forshee <seth.forshee@canonical.com>
To: Hin-Tak Leung <htl10@users.sourceforge.net>,
        Christoph Hellwig <hch@tuxera.com>
Cc: Pavel Ivanov <paivanof@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
Message-ID: <20110908162303.GA18435@ubuntu-NB505>
Mail-Followup-To: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Christoph Hellwig <hch@tuxera.com>,
	Pavel Ivanov <paivanof@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20110907175952.GC23829@thinkpad-t410>
 <1315451581.92826.YahooMailClassic@web29509.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315451581.92826.YahooMailClassic@web29509.mail.ird.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 04:13:01AM +0100, Hin-Tak Leung wrote:
> --- On Wed, 7/9/11, Seth Forshee <seth.forshee@canonical.com> wrote:
> 
> > Yes, that was definitely just an oversight. Has anyone
> > provided a patch
> > yet? If not I've pasted a patch below. Seems like a fix
> > should be
> > applied ASAP.
> > 
> > 
> > From d27825b880028e9a45ba640d86c9e8101db0606b Mon Sep 17
> > 00:00:00 2001
> > From: Seth Forshee <seth.forshee@canonical.com>
> > Date: Wed, 7 Sep 2011 10:38:35 -0700
> > Subject: [PATCH] hfsplus: Fix kfree of wrong pointers in
> > hfsplus_fill_super() error path
> > 
> > Commit 6596528 (hfsplus: ensure bio requests are not
> > smaller than
> > the hardware sectors) changed the pointers used for volume
> > header
> > allocations but failed to change the pointer freed in the
> > error
> > path of hfsplus_fill_super(). This patch fixes the
> > problem.
> > 
> > Reported-by: Pavel Ivanov <paivanof@gmail.com>
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > Cc: <stable@kernel.org>
> 
> Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
> 
> Please go ahead and submit the patch.

That was my patch submission :)

Christoph, does that work for you, or would you like me to send the
patch in a separate email?
