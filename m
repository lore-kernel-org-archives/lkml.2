Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab0JVMr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 08:47:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:42060 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab0JVMr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 08:47:58 -0400
Subject: Re: [PATCH 2/7] cgroups: Allow to bind a subsystem to a cgroup
 hierarchy
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
In-Reply-To: <4CC146D4.7030009@cn.fujitsu.com>
References: <4CC146A4.9090505@cn.fujitsu.com>
	 <4CC146D4.7030009@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 22 Oct 2010 14:47:11 +0200
Message-ID: <1287751631.15336.33.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 16:09 +0800, Li Zefan wrote:
> For example, we can't decide a cgroup's cpuset.mems and
> cpuset.cpus automatically, so cpuset is not bindable. 

You mean to say that you cannot add cpuset to an existing hierarchy
right? Not that you cannot add perf/cpuacct to an existing cpuset
hierarchy?


