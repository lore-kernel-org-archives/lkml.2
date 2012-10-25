Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992628Ab2JYUJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 16:09:11 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:37692 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760158Ab2JYUJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 16:09:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD
Date: Thu, 25 Oct 2012 22:13:05 +0200
Message-ID: <18773928.vP4l182XdI@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.3-8-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAOS58YPAVVr=itauGD9eTpfRLSBLuM8Bpyuq9AP73MDr8dPmiQ@mail.gmail.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <20121025173756.GB7650@redhat.com> <CAOS58YPAVVr=itauGD9eTpfRLSBLuM8Bpyuq9AP73MDr8dPmiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 25, 2012 10:37:31 AM Tejun Heo wrote:
> Hello,
> 
> On Thu, Oct 25, 2012 at 10:37 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> How should this be routed?  -mm?  Andrew, can you please pick this up?
> >
> > or perhaps Rafael can take it?
> 
> Yeah, that works too.  Rafael?

Yup, I'm taking it.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
