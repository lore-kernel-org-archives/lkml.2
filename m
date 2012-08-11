Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab2HKTdg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 15:33:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51680 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab2HKTdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 15:33:32 -0400
Date: Sat, 11 Aug 2012 12:33:27 -0700
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>, amwang@redhat.com,
        dyoung@redhat.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, xiyou.wangcong@gmail.com, rjw@sisk.pl,
        yinghai.lu@oracle.com, tiwai@suse.de, kexec@lists.infradead.org
Subject: Re: [PATCH] x86: revert "x86: Fix S4 regression"
Message-ID: <20120811193327.GB2874@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1339478463-31172-1-git-send-email-amwang@redhat.com>
 <5004D8BF.6050205@jp.fujitsu.com>
 <500D20A1.1030800@redhat.com>
 <500D340F.5080801@jp.fujitsu.com>
 <1343145331.16290.45.camel@cr0>
 <500F3B7C.70009@jp.fujitsu.com>
 <20120811175759.GA1814@cantor.Home>
 <20120811182644.GA1787@cantor.Home>
 <5026A5AE.6050608@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5026A5AE.6050608@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 11:34:22AM -0700, H. Peter Anvin wrote:
> On 08/11/2012 11:26 AM, Jerry Snitselaar wrote:
> >>
> >>This patch from Jacob Shin solves the problem, and seems like it might
> >>be a better solution.
> >>
> >>[PATCH 2/5] x86: find_early_table_space based on memory ranges that
> >>are being mapped
> >>
> >>https://lkml.org/lkml/2012/8/9/540
> >>
> >Actually, apply that series of 5 patches.
> >
> 
> I was hoping Tejun would comment on it, but I think I'll pull it into -tip.

Wasn't cc'd.  Will take a look.

Thanks.

-- 
tejun
