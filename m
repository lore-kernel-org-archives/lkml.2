Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab1HCErc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 00:47:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab1HCErY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 00:47:24 -0400
Date: Wed, 3 Aug 2011 00:47:20 -0400
From: Dave Jones <davej@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: git commit id and tarball's filename mapping.
Message-ID: <20110803044720.GA26161@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	linux-kernel@vger.kernel.org
References: <201108030442.p734gwO9050751@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108030442.p734gwO9050751@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 01:42:58PM +0900, Tetsuo Handa wrote:
 > Hello.
 > 
 > I regularly test kernels extracted from tarballs rather than from git. I have
 > problems with estimating range to "git bisect" because I can't know commit id
 > as of a tarball was archived. I would appreciate if there is a mapping table
 > that contains commit id and tarball's filename.
 > 
 > 0123456789012345678901234567890123456789 linux-3.0.tar.bz2
 > 1234567890123456789012345678901234567890 patch-3.0-git1.bz2
 > 2345678901234567890123456789012345678901 patch-3.0-git2.bz2
 > 3456789012345678901234567890123456789012 patch-3.0-git3.bz2
 >   (...snipped...)
 > 7890123456789012345678901234567890123456 patch-3.0-git17.bz2
 > 8901234567890123456789012345678901234567 linux-3.1-rc1.tar.bz2

for the patches, there's an associated .id file in the same dir.
Seems to be lacking for the tarballs though.

	Dave

