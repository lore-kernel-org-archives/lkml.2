Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab0HXHNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:13:50 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:40538 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab0HXHNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:13:48 -0400
Date: Tue, 24 Aug 2010 09:13:44 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: manual merge of the block tree with the s390 tree
Message-ID: <20100824091344.3945ccdc@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100824105328.9bf22335.sfr@canb.auug.org.au>
References: <20100824105328.9bf22335.sfr@canb.auug.org.au>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, 24 Aug 2010 10:53:28 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jens,
> 
> Today's linux-next merge of the block tree got a conflict in
> drivers/s390/char/tape_block.c between commit
> 7dc74a8fdb22f4410a2d8e45353c9ea75821a9ba ("[S390] tape: fix kernel panic
> when setting tape device offline") from the s390 tree and commit
> 52cc2eef31587b22ce9fbe77b064a031a9613ab0 ("block: switch s390 tape_block
> and mg_disk to elevator_change()") from the block tree.
> 
> I assume that the latter removes the need for the former, so I used that.

The patch in the block tree includes the fix for the s390 tape driver.
So I guess its best if I remove the s390 specific patch from the
git390 tree.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

