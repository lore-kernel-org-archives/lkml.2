Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274Ab0KMAnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 19:43:23 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:42111 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab0KMAnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 19:43:20 -0500
Subject: Re: [GIT PULL] SCSI queuecommand API change for 2.6.37-rc1
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1289606118.3015.539.camel@mulgrave.site>
References: <1289606118.3015.539.camel@mulgrave.site>
Content-Type: text/plain
Date: Fri, 12 Nov 2010 16:38:08 -0800
Message-Id: <1289608688.22107.9.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 17:55 -0600, James Bottomley wrote:
> This patch set contains a single patch modifying the SCSI queuecommand
> host template API to go from being called with the host lock held to
> being called locklessly.  The transformation is a directly equivalent
> one (i.e. the locking is simply pushed into each HBA) but will form the
> basis for optimising locking in the driver patch for the next merge
> window.
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> 
> The short changelog is:
> 
> Jeff Garzik (1):
>       host lock push-down
> 

Hi James and Co,

Please feel free to add my review signoff for jgarzik's work.

Thanks!

Reviewed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

