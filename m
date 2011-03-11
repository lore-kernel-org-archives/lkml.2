Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1CKTJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:09:42 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47578 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256Ab1CKTJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:09:40 -0500
Message-ID: <4D7A7373.8090800@kernel.dk>
Date: Fri, 11 Mar 2011 20:09:39 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Subject: Re: [PATCH] cciss: Add missing allocation in scsi_cmd_stack_setup
 and  corresponding deallocation
References: <20110310202238.30533.92210.stgit@beardog.cce.hp.com>
In-Reply-To: <20110310202238.30533.92210.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-10 21:22, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> This bit got lost somewhere along the way.  Without this, panic.

This doesn't apply cleanly, neither hunk. I hand applied it. Please let
me know what a patch is against in the future, if it doesn't apply
"anywhere".

I marked this one as stable backport, too.

-- 
Jens Axboe

