Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab2HQVRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 17:17:31 -0400
Received: from 1wt.eu ([62.212.114.60]:5788 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216Ab2HQVRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 17:17:25 -0400
Date: Fri, 17 Aug 2012 23:13:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: John Stultz <john.stultz@linaro.org>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [v2.6.34-stable 109/165] ntp: Fix leap-second hrtimer livelock
Message-ID: <20120817211322.GB495@1wt.eu>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com> <1345060109-9187-110-git-send-email-paul.gortmaker@windriver.com> <20120817161711.GE4039@herton-Z68MA-D2H-B3> <502E74B9.8010300@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502E74B9.8010300@linaro.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 09:43:37AM -0700, John Stultz wrote:
> I also have another change pending in -tip that I've marked for 
> stable. Once that lands I'm planning on reviewing the current stable 
> trees to check that they have all the needed changes.

John, for the record, I have already queued your whole 2.6.32 patchset
as well as the aforementionned fix (ntp-Fix-STA_INS-DEL-clearing-bug).

Thanks,
Willy

