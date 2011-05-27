Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1E0Nrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:47:55 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55072 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753011Ab1E0Nrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:47:52 -0400
Subject: Re: linux-next: build failure after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110527132511.20174ce1.sfr@canb.auug.org.au>
References: <20110527132511.20174ce1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 08:47:48 -0500
Message-ID: <1306504068.3264.0.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 13:25 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the scsi tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "blk_put_queue" [drivers/scsi/scsi_mod.ko] undefined!
> ERROR: "blk_get_queue" [drivers/scsi/scsi_mod.ko] undefined!
> 
> Caused by commit 069a596c12ca ("[SCSI] Fix oops caused by queue
> refcounting failure").
> 
> I have used the scsi tree from next-20110526 for today.

I dropped the patch for now and am circling back around with Jens to get
the necessary EXPORT_SYMBOL_GPL() tags added.

Thanks,

James


