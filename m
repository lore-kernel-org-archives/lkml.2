Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1BMQS2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 11:18:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab1BMQSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 11:18:23 -0500
Date: Sun, 13 Feb 2011 11:13:30 -0500
From: Josef Bacik <josef@redhat.com>
To: Marti Raudsepp <marti@juffo.org>
Cc: Josef Bacik <josef@redhat.com>,
        btrfs hackers <linux-btrfs@vger.kernel.org>,
        Kernel hackers <linux-kernel@vger.kernel.org>
Subject: Re: btrfs: compression breaks cp and cross-FS mv, FS_IOC_FIEMAP
	bug?
Message-ID: <20110213161329.GL19533@dhcp231-156.rdu.redhat.com>
References: <AANLkTinZNk1j94rEMVdvRtjr2Sa-C7VpQOGHrvrY8Hph@mail.gmail.com> <20110213155730.GK19533@dhcp231-156.rdu.redhat.com> <AANLkTi=Rj_3MmLawJj-K8u+pGbT_NZzqzVGFOsvOK8eC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=Rj_3MmLawJj-K8u+pGbT_NZzqzVGFOsvOK8eC@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 06:07:36PM +0200, Marti Raudsepp wrote:
> On Sun, Feb 13, 2011 at 17:57, Josef Bacik <josef@redhat.com> wrote:
> > Does the same problem happen when you use cp --sparse=never?
> 
> You are right. cp --sparse=never does not cause data loss.
>

So fiemap probably isn't doing the right thing when compression is enabled,
which doesn't suprise me since we don't do the right thing with delalloc either.
I will try and get to this soon.  Thanks,

Josef 
