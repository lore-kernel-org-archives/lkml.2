Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab1CXVQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:16:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28074 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab1CXVQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:16:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=DwoHvJbRserdmVN2DVK4uzU8eWtjsE4TdZz1Z4XcYksGjvh0VrxHN4JD8HPauHfH/l
         vYyGC/bVA9FpCHXf/New==
MIME-Version: 1.0
In-Reply-To: <AANLkTimPWxVeax3RcVBefPeV5+P8G6cHhdU-g82_s5s3@mail.gmail.com>
References: <AANLkTinmjGaK9ZSbKYTm5g-wuQ-K1hQaJBA+gSN5ERJ=@mail.gmail.com>
 <AANLkTikHqJR=JgZzKc1G-m8z82hBFmD-w1bLn5aENTcr@mail.gmail.com> <AANLkTimPWxVeax3RcVBefPeV5+P8G6cHhdU-g82_s5s3@mail.gmail.com>
From: Paul Menage <menage@google.com>
Date: Thu, 24 Mar 2011 14:16:27 -0700
Message-ID: <AANLkTimRqvy4JseWka9HfwvmirbUxcTEBy5OTg4UiQiZ@mail.gmail.com>
Subject: Re: Tests for cpusets and cgroup performance measurement
To: Jaswinder Singh <jaswinderlinux@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 10:42 PM, Jaswinder Singh
<jaswinderlinux@gmail.com> wrote:
> "Jobs on larger NUMA systems may see a performance boost if jobs can be
> intelligently assigned to specific CPUs. Jobs may perform better if
> striped across physical processors, or contained within the fewest
> number of memory controllers."
>
> I am curious and want to try some simple tests so that I can see the
> performance improvement by using cpusets on my PCs.
>
> Can you suggest some tests so that I can study them.

Not particularly - I've never been involved in optimizing apps on
large NUMA systems. Our uses of NUMA at Google have all involved
faked-NUMA nodes, assigning nodes to jobs to provide crude memory
limits.

I suspect that there aren't very many "simple" tests out there. Google
search for [hpc numa tuning] turns up a few likely pages that might
have pointers to suitable applications.

Paul
