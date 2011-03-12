Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1CLJDm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 04:03:42 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60664 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab1CLJDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 04:03:37 -0500
Message-ID: <4D7B36E6.2050702@kernel.dk>
Date: Sat, 12 Mar 2011 10:03:34 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Subject: Re: [PATCH 0/7] cciss: updates as of March 11, 2011
References: <20110311205306.2211.53569.stgit@beardog.cce.hp.com>
In-Reply-To: <20110311205306.2211.53569.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-11 21:55, Stephen M. Cameron wrote:
> The following series is vs. Jens Axboe's for-2.6.39/drivers branch. 
> 
> ---
> 
> Stephen M. Cameron (7):
>       cciss: hoist tag masking out of loop
>       cciss: Inform controller we are using 32-bit tags.
>       cciss: Mask off error bits of c->busaddr in cmd_special_free when calling pci_free_consistent
>       cciss: remove unnecessary casts
>       cciss: fix missed command status value CMD_UNABORTABLE
>       cciss: add cciss_tape_cmds module paramter
>       cciss: export resettable host attribute

I have applied 1-5/7, 6 and 7 do not apply. Please check
for-2.6.39/drivers and check and resend those last two patches.

-- 
Jens Axboe

