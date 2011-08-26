Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1HZPSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 11:18:49 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42084 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab1HZPSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 11:18:48 -0400
MIME-Version: 1.0
In-Reply-To: <20110826151245.GA16243@redhat.com>
References: <201108252044.p7PKiaHd006997@imap1.linux-foundation.org> <20110826151245.GA16243@redhat.com>
From: Paul Menage <paul@paulmenage.org>
Date: Fri, 26 Aug 2011 08:18:26 -0700
X-Google-Sender-Auth: HBftD7aGUPRVJ0Q3kwE8f2fDv9U
Message-ID: <CALdu-PBaEJFvM4s4Kspm4Au-wfdAL0te8dLpdqO7dO+xfvWvaA@mail.gmail.com>
Subject: Re: + cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch added
 to -mm tree
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        bblum@andrew.cmu.edu, fweisbec@gmail.com, lizf@cn.fujitsu.com,
        tj@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 8:12 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
>
>
> But this doesn't answer my another question. After that the code does
>
>         * step 4: do expensive, non-thread-specific subsystem callbacks.
>
>                ss->attach(ss, cgrp, oldcgrp, leader);
>
> OK, non-thread-specific is nice, but how can this "leader" represent
> the process?

There's a set of patches from Tejun Heo that address some of these
inconsistencies and lack of information - search the list for
cgroup_taskset.

Paul
