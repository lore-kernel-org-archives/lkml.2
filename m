Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab2GTH30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 03:29:26 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47397 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751912Ab2GTH3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 03:29:23 -0400
Message-ID: <1342769360.2984.2.camel@dabdike.int.hansenpartnership.com>
Subject: Re: linux-next: manual merge of the scsi tree with Linus' tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Date: Fri, 20 Jul 2012 08:29:20 +0100
In-Reply-To: <20120720103254.4a043ea94ef16992466a8b19@canb.auug.org.au>
References: <20120720103254.4a043ea94ef16992466a8b19@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 10:32 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> Today's linux-next merge of the scsi tree got a conflict in
> drivers/scsi/scsi_wait_scan.c between commit eea03c20ae38 ("Make
> wait_for_device_probe() also do scsi_complete_async_scans()") from Linus'
> tree and commit 01444e1106cb ("[SCSI] Remove scsi_wait_scan module") from
> the scsi tree.
> 
> I just removed the file.

That won't quite work; there's a lot of nasty fallout ... I'll actually
have to rebase the misc and async branches to fix this.

By the way, Linus, the patch says:

    Cc: Dan Williams <dan.j.williams@gmail.com>
    Cc: Alan Stern <stern@rowland.harvard.edu>
    Cc: James Bottomley <jbottomley@parallels.com>
    Cc: Borislav Petkov <bp@amd64.org>
    Cc: linux-scsi <linux-scsi@vger.kernel.org>

But best I can tell it never went to either me or linux-scsi.

James


