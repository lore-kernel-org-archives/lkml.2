Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab0HXIRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:17:48 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55852 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab0HXIRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:17:45 -0400
Message-ID: <4C738037.20201@kernel.dk>
Date: Tue, 24 Aug 2010 10:17:59 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: manual merge of the block tree with the s390 tree
References: <20100824105328.9bf22335.sfr@canb.auug.org.au> <20100824091344.3945ccdc@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100824091344.3945ccdc@mschwide.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-24 09:13, Martin Schwidefsky wrote:
> Hi Stephen,
> 
> On Tue, 24 Aug 2010 10:53:28 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
>> Hi Jens,
>>
>> Today's linux-next merge of the block tree got a conflict in
>> drivers/s390/char/tape_block.c between commit
>> 7dc74a8fdb22f4410a2d8e45353c9ea75821a9ba ("[S390] tape: fix kernel panic
>> when setting tape device offline") from the s390 tree and commit
>> 52cc2eef31587b22ce9fbe77b064a031a9613ab0 ("block: switch s390 tape_block
>> and mg_disk to elevator_change()") from the block tree.
>>
>> I assume that the latter removes the need for the former, so I used that.
> 
> The patch in the block tree includes the fix for the s390 tape driver.
> So I guess its best if I remove the s390 specific patch from the
> git390 tree.
> 

Probably best, since the change in my tree is different from the
one you likely merged. So it will clash, as Stephen also reports.

-- 
Jens Axboe

