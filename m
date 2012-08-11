Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab2HKR6K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 13:58:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63622 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2HKR6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 13:58:05 -0400
Date: Sat, 11 Aug 2012 10:57:59 -0700
From: Jerry Snitselaar <dev@snitselaar.org>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: amwang@redhat.com, dyoung@redhat.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, xiyou.wangcong@gmail.com, hpa@zytor.com,
        rjw@sisk.pl, yinghai.lu@oracle.com, tiwai@suse.de,
        kexec@lists.infradead.org
Subject: Re: [PATCH] x86: revert "x86: Fix S4 regression"
Message-ID: <20120811175759.GA1814@cantor.Home>
Reply-To: Jerry Snitselaar <dev@snitselaar.org>
Mail-Followup-To: Takao Indoh <indou.takao@jp.fujitsu.com>,
	amwang@redhat.com, dyoung@redhat.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, xiyou.wangcong@gmail.com, hpa@zytor.com,
	rjw@sisk.pl, yinghai.lu@oracle.com, tiwai@suse.de,
	kexec@lists.infradead.org
References: <1339478463-31172-1-git-send-email-amwang@redhat.com>
 <5004D8BF.6050205@jp.fujitsu.com>
 <500D20A1.1030800@redhat.com>
 <500D340F.5080801@jp.fujitsu.com>
 <1343145331.16290.45.camel@cr0>
 <500F3B7C.70009@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500F3B7C.70009@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Jul 25 12, Takao Indoh wrote:
> >Thanks for tracking this, Takao!
> >
> >I bet you are using x86_64 not x86 PAE? If so, could you try this patch
> >https://patchwork.kernel.org/patch/1195751/
> >? I already reviewed it.
> 
> Great, I applied it and now kdump works. Thanks!
> 
> Thanks,
> Takao Indoh
> 

This patch from Jacob Shin solves the problem, and seems like it might
be a better solution.

[PATCH 2/5] x86: find_early_table_space based on memory ranges that
are being mapped

https://lkml.org/lkml/2012/8/9/540

