Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1CJJuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 04:50:12 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36206 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab1CJJuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 04:50:11 -0500
Message-ID: <4D789ED1.6060905@kernel.dk>
Date: Thu, 10 Mar 2011 10:50:09 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>
CC: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [GIT PULL] DRBD bits for 2.6.39
References: <201103091523.51815.philipp.reisner@linbit.com>
In-Reply-To: <201103091523.51815.philipp.reisner@linbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-09 15:23, Philipp Reisner wrote:
> The following changes since commit cd9bd3a0b4d9f3943753a949fff411c719530f8c:
> 
>   staging: Convert to bdops->check_events() (2011-03-09 10:19:17 +0100)
> 
> are available in the git repository at:
>   git://git.drbd.org/linux-2.6-drbd.git for-jens

Philip, sorry for the extra work, but can I please ask you to rebase
this on the new for-2.6.39/core? Two things happened:

- I pulled in the stack-plug changes, it's causing a few conflicts. All
  of them are trivial, so that's not a real worry.

- I had to rebase for-2.6.39/core to get rid of an OOPS in the
  ->check_events() changes from Tejun.

-- 
Jens Axboe

