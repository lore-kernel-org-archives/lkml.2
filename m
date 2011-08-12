Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1HLRoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:44:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65006 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab1HLRoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:44:20 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=qJL5OhcabBcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=9dqYV_22NHa5PD8XHyoA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [KTEST PATCH 00/10] collection of ktest patches
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Jones <drjones@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1313155932-20092-1-git-send-email-drjones@redhat.com>
References: <1313155932-20092-1-git-send-email-drjones@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Aug 2011 13:44:18 -0400
Message-ID: <1313171058.18583.347.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 15:32 +0200, Andrew Jones wrote:
> More than once I've had to drive git-bisect to bisect boot issues for
> Xen guests. The last time I needed to do so I decided to give ktest a
> whirl. While whirling I wrote a couple patches and added a few features.
> This patchset is the collection.

I do like your changes and I'll start queuing them up soon. Probably
need to rename the PASS_COUNT though. What do you think of RERUN?

Anyway, I only post to Linus during the merge window (except for bug
fixes), which means they wont be in mainline until 3.2.

The best thing about this patchset, is that it proves that ktest is used
by more than 1 person. It's doubled its usage statistics!

-- Steve

> 
> Andrew Jones (10):
>   ktest: create outputdir, if it doesn't exist
>   ktest: small cleanup
>   ktest: factor reboot code
>   ktest: Introduce RESET_TIME
>   ktest: refactor monitor/boot/test code
>   ktest: make start_monitor_and_boot true to its name
>   ktest: Introduce PASS_COUNT
>   ktest: test faster, put REBOOT_ON_SUCCESS to more work
>   ktest: test faster, favor rsync over the tarball method
>   ktest: Introduce FAILURE_LINE
> 
>  tools/testing/ktest/ktest.pl    |  208 +++++++++++++++++++++++----------------
>  tools/testing/ktest/sample.conf |   23 ++++-
>  2 files changed, 147 insertions(+), 84 deletions(-)
> 


