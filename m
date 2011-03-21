Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1CURde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:33:34 -0400
Received: from smtp-out.google.com ([74.125.121.67]:22039 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab1CURdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:33:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=jNQIuMFoDMFrKr/KkdA1uWt3XSohlRBR+8k3cose4qzd5ftlC79Z82li2TJH/Tsw/M
         25sDP/it4U9VeD8rN7jA==
MIME-Version: 1.0
In-Reply-To: <AANLkTinmjGaK9ZSbKYTm5g-wuQ-K1hQaJBA+gSN5ERJ=@mail.gmail.com>
References: <AANLkTinmjGaK9ZSbKYTm5g-wuQ-K1hQaJBA+gSN5ERJ=@mail.gmail.com>
From: Paul Menage <menage@google.com>
Date: Mon, 21 Mar 2011 10:33:08 -0700
Message-ID: <AANLkTikHqJR=JgZzKc1G-m8z82hBFmD-w1bLn5aENTcr@mail.gmail.com>
Subject: Re: Tests for cpusets and cgroup performance measurement
To: Jaswinder Singh <jaswinderlinux@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 3:42 AM, Jaswinder Singh
<jaswinderlinux@gmail.com> wrote:
>
> Can you please suggest some simple tests to measure the performance
> enhancement by using cpusets/cgroups.

The cgroups framework is simply a way of grouping processes together
and allowing subsystems (memory, CPU, disk I/O, etc) to associate
state objects with each group. Generally this is for improving
isolation rather than improving performance - sticking extra machinery
and scheduling in will typically reduce overall throughput, but make
it more practical to share resources safely between multiple groups of
processes.

Your question is pretty open-ended - what's your ultimate goal? You
should probably be focusing on some particular problem that you're
trying to measure/improve via resource isolation/scheduling.

Paul
