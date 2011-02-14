Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab1BNSD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:03:28 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:37561 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1BNSDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:03:24 -0500
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Marti Raudsepp <marti@juffo.org>
Cc: Josef Bacik <josef@redhat.com>,
        btrfs hackers <linux-btrfs@vger.kernel.org>,
        Kernel hackers <linux-kernel@vger.kernel.org>
Subject: Re: btrfs: compression breaks cp and cross-FS mv, FS_IOC_FIEMAP bug?
In-reply-to: <AANLkTi=N8DiusfP6Rey=Cx4qjUSbiLS3jnbjASGQ=Lcx@mail.gmail.com>
References: <AANLkTinZNk1j94rEMVdvRtjr2Sa-C7VpQOGHrvrY8Hph@mail.gmail.com> <20110213155730.GK19533@dhcp231-156.rdu.redhat.com> <AANLkTi=Rj_3MmLawJj-K8u+pGbT_NZzqzVGFOsvOK8eC@mail.gmail.com> <20110213161329.GL19533@dhcp231-156.rdu.redhat.com> <1297695521-sup-9460@think> <AANLkTi=N8DiusfP6Rey=Cx4qjUSbiLS3jnbjASGQ=Lcx@mail.gmail.com>
Date: Mon, 14 Feb 2011 13:01:32 -0500
Message-Id: <1297706458-sup-9378@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D596E5E.00F7:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Marti Raudsepp's message of 2011-02-14 12:58:17 -0500:
> On Mon, Feb 14, 2011 at 17:01, Chris Mason <chris.mason@oracle.com> wrote:
> > Or, it could just be delalloc ;)
> 
> I suspect delalloc. After creating the file, filefrag reports "1
> extent found", but for some reason it doesn't actually print out
> details of the extent.
> 
> After a "sync" call, the extent appears and "cp" starts working as expected:

Great, that's a ton easier than fixing cp.

-chris
