Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031303Ab2B2TMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:12:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:35694 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758031Ab2B2TML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:12:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112917985"
From: Andi Kleen <andi@firstfloor.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Questions about ptrace on a dying process
References: <4F4E6915.1010209@am.sony.com>
Date: Wed, 29 Feb 2012 11:12:02 -0800
In-Reply-To: <4F4E6915.1010209@am.sony.com> (Tim Bird's message of "Wed, 29
	Feb 2012 10:06:13 -0800")
Message-ID: <m2mx81pi7x.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird <tim.bird@am.sony.com> writes:

> ptrace maintainers (and interested parties)...
>
> I'm working on a crash handler for Linux, which uses ptrace to retrieve information
> about a process during it's coredump.  Specifically, from within a core handler
> program (started within do_coredump() as a user_mode_helper), I would like to make
> ptrace calls against the dying process.

The standard approach is to define a core pipe handler and parse the
elf memory dump.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
