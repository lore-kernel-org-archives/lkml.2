Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab1HCFC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 01:02:29 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57941 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab1HCFCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 01:02:22 -0400
X-Nat-Received: from [202.181.97.72]:59457 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1312347738.9650
Message-Id: <201108030502.p7352IDa055880@www262.sakura.ne.jp>
Subject: Re: git commit id and tarball's filename mapping.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: davej@redhat.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 03 Aug 2011 14:02:18 +0900
References: <201108030442.p734gwO9050751@www262.sakura.ne.jp> <20110803044720.GA26161@redhat.com>
In-Reply-To: <20110803044720.GA26161@redhat.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 03082011 #5774370, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Wed, Aug 03, 2011 at 01:42:58PM +0900, Tetsuo Handa wrote:
>  > I regularly test kernels extracted from tarballs rather than from git. I have
>  > problems with estimating range to "git bisect" because I can't know commit id
>  > as of a tarball was archived. I would appreciate if there is a mapping table
>  > that contains commit id and tarball's filename.
> 
> for the patches, there's an associated .id file in the same dir.
Oh, that's good.

> Seems to be lacking for the tarballs though.
We can use alias names assigned by "git tag".

Thank you.
