Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab1HYJGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 05:06:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44301 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab1HYJGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 05:06:30 -0400
Date: Thu, 25 Aug 2011 11:06:26 +0200
From: Tejun Heo <tj@kernel.org>
To: Paul Menage <paul@paulmenage.org>
Cc: rjw@sisk.pl, lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 5/6] cgroup, cpuset: don't use ss->pre_attach()
Message-ID: <20110825090626.GE3286@htj.dyndns.org>
References: <1314138000-2049-1-git-send-email-tj@kernel.org>
 <1314138000-2049-6-git-send-email-tj@kernel.org>
 <CALdu-PD5EbFJBRHf-iehPwb6vyJTYUTWZniihARFDZ7xRZ8_nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALdu-PD5EbFJBRHf-iehPwb6vyJTYUTWZniihARFDZ7xRZ8_nQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 01:53:57AM -0700, Paul Menage wrote:
> On Tue, Aug 23, 2011 at 3:19 PM, Tejun Heo <tj@kernel.org> wrote:
> > ->pre_attach() is supposed to be called before migration, which is
> > observed during process migration but task migration does it the other
> > way around.  The only ->pre_attach() user is cpuset which can do the
> > same operaitons in ->can_attach().  Collapse cpuset_pre_attach() into
> > cpuset_can_attach().
> >
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> Acked-by: Paul Menage <paul@paulmenage.org>
> 
> Code looks good, but I think that the some of the Documentation
> changes slipped in here by mistake.

Oops, indeed.  Will relocate them.

Thanks.

-- 
tejun
