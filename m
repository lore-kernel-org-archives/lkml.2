Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab1JGCEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 22:04:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:12810 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759236Ab1JGCEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 22:04:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,499,1312182000"; 
   d="scan'208";a="71125455"
From: Andi Kleen <andi@firstfloor.org>
To: Cyclonus J <cyclonusj@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: intercommunications between Linux kernel modules
References: <CAOzbF4dvtM5WJ9-LkP4tFROA_gnT-gh-+-3qJLSqtUKOp0SvMg@mail.gmail.com>
Date: Thu, 06 Oct 2011 19:04:09 -0700
In-Reply-To: <CAOzbF4dvtM5WJ9-LkP4tFROA_gnT-gh-+-3qJLSqtUKOp0SvMg@mail.gmail.com>
	(Cyclonus J.'s message of "Thu, 6 Oct 2011 18:53:05 -0700")
Message-ID: <m28vox36cm.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyclonus J <cyclonusj@gmail.com> writes:

> I am looking for a way to do an IPC-like communications between two
> linux kernel modules, such as mqueue or shared memory. After searching
> for a while, I can't find such information available inside existing
> linux kernel or online.
>
> So, my question is if this is something discussed before here and gets
> rejected or still might be accepted in the mainstream kernel tree?

All kernel memory is shared in Linux, so the concept doesn't make sense.

If you want to send messages or communicate inside the kernel there are
lots of different facilities available.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
