Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992524Ab2JYRhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:37:34 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:63018 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935887Ab2JYRhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:37:32 -0400
MIME-Version: 1.0
In-Reply-To: <20121025173756.GB7650@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
	<1350426526-14254-5-git-send-email-tj@kernel.org>
	<20121022183453.GA24687@redhat.com>
	<20121022211822.GF5951@atj.dyndns.org>
	<20121023155533.GC16201@redhat.com>
	<20121024190651.GC12182@atj.dyndns.org>
	<20121025171236.GA6776@redhat.com>
	<20121025171256.GB6776@redhat.com>
	<20121025172016.GF11442@htj.dyndns.org>
	<20121025173756.GB7650@redhat.com>
Date: Thu, 25 Oct 2012 10:37:31 -0700
X-Google-Sender-Auth: tznora1F5chDLvZqR1doAITHMuY
Message-ID: <CAOS58YPAVVr=itauGD9eTpfRLSBLuM8Bpyuq9AP73MDr8dPmiQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 25, 2012 at 10:37 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> How should this be routed?  -mm?  Andrew, can you please pick this up?
>
> or perhaps Rafael can take it?

Yeah, that works too.  Rafael?

-- 
tejun
