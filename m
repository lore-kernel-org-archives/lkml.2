Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828Ab2BJTWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:22:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39155 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab2BJTWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:22:04 -0500
Date: Fri, 10 Feb 2012 11:21:57 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] ptrace: remove PTRACE_SEIZE_DEVEL bit
Message-ID: <20120210192157.GI19392@google.com>
References: <1328884991-23889-1-git-send-email-vda.linux@googlemail.com>
 <1328884991-23889-2-git-send-email-vda.linux@googlemail.com>
 <1328884991-23889-3-git-send-email-vda.linux@googlemail.com>
 <1328884991-23889-4-git-send-email-vda.linux@googlemail.com>
 <1328884991-23889-5-git-send-email-vda.linux@googlemail.com>
 <1328884991-23889-6-git-send-email-vda.linux@googlemail.com>
 <20120210172427.GE8908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210172427.GE8908@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 06:24:27PM +0100, Oleg Nesterov wrote:
> On 02/10, Denys Vlasenko wrote:
> >
> > PTRACE_SEIZE code is tested and ready for production use,
> > remove the code which requires special bit in data argument
> > to make PTRACE_SEIZE work.
> >
> > Strace team prepares for a new release of strace, and we
> > would like to ship the code which uses PTRACE_SEIZE,
> > preferably after this change goes into released kernel.
> >
> > Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> 
> Personally I agree with this change. PTRACE_SEIZE_DEVEL complicates
> the testing/development for the user-space.
> 
> Tejun, do you agree?
> 
> Acked-by: Oleg Nesterov <oleg@redhat.com>

Yeah, I was thinking about sending a patch to remove DEVEL flag myself
and other changes seem good to me too.  For the whole series,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
