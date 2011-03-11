Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1CKUI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:08:29 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35357 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab1CKUI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:08:28 -0500
Message-ID: <4D7A8139.3010101@kernel.dk>
Date: Fri, 11 Mar 2011 21:08:25 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: scameron@beardog.cce.hp.com
CC: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Subject: Re: [PATCH] cciss: Add missing allocation in scsi_cmd_stack_setup
 and  corresponding deallocation
References: <20110310202238.30533.92210.stgit@beardog.cce.hp.com> <4D7A7373.8090800@kernel.dk> <20110311194644.GE12760@beardog.cce.hp.com>
In-Reply-To: <20110311194644.GE12760@beardog.cce.hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-11 20:46, scameron@beardog.cce.hp.com wrote:
> On Fri, Mar 11, 2011 at 08:09:39PM +0100, Jens Axboe wrote:
>> On 2011-03-10 21:22, Stephen M. Cameron wrote:
>>> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>>>
>>> This bit got lost somewhere along the way.  Without this, panic.
>>
>> This doesn't apply cleanly, neither hunk. I hand applied it. Please let
>> me know what a patch is against in the future, if it doesn't apply
>> "anywhere".
> 
> Oh... I see what happened.
> 
> That patch was fixing something which was accidentally 
> left out of this patch:
> 
> http://marc.info/?l=linux-kernel&m=129840572232151&w=2
> 
> which I mistakenly thought was present in 2.6.38-rc7,
> but it's not present (quite likely because without the
> missing bit, it causes a panic), It's sitting in my stack of
> patches still.
> 
> [scameron@localhost linux-2.6.38-rc7]$ stg series | grep cciss
> + cciss-hoist-tag-masking-out-of-loop
> + cciss-inform-controller-we-are-using-32-bit-tags
> + cciss-mask-off-error-bits-before-calling-pci-free-consistent
> + cciss-remove-unnecessary-casts
> + cciss-fix-missed-command-status-value-CMD_UNABORTABLE
> + cciss-add-cciss_tape_cmds-module-parameter
> + cciss-fix-missing-initialization-in-scsi-cmd-stack-setup
> + cciss-export-resettable-host-attribute
> + cciss-fix-sense-data-copying-code
> 
> What needs to happen is I combine cciss-add-cciss_tape_cmds-module-parameter
> and cciss-fix-missing-initialization-in-scsi-cmd-stack-setup into one 
> working patch.

Please check what is missing for my for-2.6.39/drivers branch and send
me the patches.

-- 
Jens Axboe

