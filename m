Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab2BWWBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:01:22 -0500
Received: from mga14.intel.com ([143.182.124.37]:30398 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab2BWWBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:01:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="110102532"
From: Andi Kleen <andi@firstfloor.org>
To: Neil Clarkson <neilaclarkson@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext4 superblock last write time clearly isnt the last write time
References: <CADzG2TCx8OtpBqwEA1VNN-PUFcPU5WBns2D5LtsZZu9mXUgeOQ@mail.gmail.com>
Date: Thu, 23 Feb 2012 14:01:24 -0800
In-Reply-To: <CADzG2TCx8OtpBqwEA1VNN-PUFcPU5WBns2D5LtsZZu9mXUgeOQ@mail.gmail.com>
	(Neil Clarkson's message of "Thu, 23 Feb 2012 21:27:50 +0000")
Message-ID: <m2r4xlp5u3.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Clarkson <neilaclarkson@gmail.com> writes:

> Isn't the s_wtime field of the ext4 superblock supposed to show the
> time, in seconds since the epoch, of the last write to the file
> system? 

Last write to the super block. Obviously last write to the file system
would be incredible expensive: every write to the file system would
cause a super block write too, doubling all write IO.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
