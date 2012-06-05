Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab2FEXhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 19:37:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:45930 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab2FEXhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:37:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="148653865"
From: Andi Kleen <andi@firstfloor.org>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Kees Cook <keescook@chromium.org>, "Ted Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>, <dm-devel@redhat.com>,
        <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group 1904, 32254 clusters in bitmap, 32258 in gd
References: <471046920.20120604234941@eikelenboom.it>
	<20120605000356.GM29466@outflux.net>
	<1018371644.20120605224154@eikelenboom.it>
Date: Tue, 05 Jun 2012 16:37:38 -0700
In-Reply-To: <1018371644.20120605224154@eikelenboom.it> (Sander Eikelenboom's
	message of "Tue, 5 Jun 2012 22:41:54 +0200")
Message-ID: <m2aa0hjpod.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sander Eikelenboom <linux@eikelenboom.it> writes:
>
> Hmm that seems consistent with this report which mentions 3.1.5 as last working kernel:
> http://comments.gmane.org/gmane.comp.file-systems.ext4/30575
>
> So somehow this only effects ext4 on DM (it's THE common factor in all reports) and fsck seems incapable of seeing the error (and thus repair it.)

I have a system that throws this error all the time and it's not using
DM.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
