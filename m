Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab1EaSXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:23:03 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51250 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1EaSXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:23:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hlqgHyt2nM+Oh3lwtacRptsGy/xd6UJI1Tgo1LLBebKUrDoNOQlMXJ57sQorR33Du4
         /l1uIt63VWXjVZQZkfCLVK9X4dTmxHdQ5vUJ2uP/waTSZi8lt7z717ADPCxFsH8SOusD
         ciuqsbzvB9IMAH8bQyc6yMeNhemZLyg+Y73yM=
Date: Tue, 31 May 2011 20:22:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@alien8.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: Split up buffer handling from core code
Message-ID: <20110531182252.GA5256@somewhere.redhat.com>
References: <1305767185-5771-1-git-send-email-fweisbec@gmail.com>
 <1305827704-5607-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305827704-5607-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 07:55:04PM +0200, Frederic Weisbecker wrote:
> And create the internal perf events header.
> 
> v2: Keep an internal inlined perf_output_copy()
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Stephane Eranian <eranian@google.com>
> ---

Are you guys fine with his patch?
If so, should I queue it myself and send a pull request?

I prefer to work step by step on this split, to avoid
too much review burden. And also a single detail
can require to rework the whole.
