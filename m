Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab1AEJnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 04:43:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:35974 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab1AEJns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 04:43:48 -0500
Subject: Re: cgroup scheduling: Adding kthreadd to a non-RT cgroup can
 deadlock the kernel
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nelson Elhage <nelhage@ksplice.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110105045447.GN23414@ksplice.com>
References: <20110105045447.GN23414@ksplice.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 10:44:10 +0100
Message-ID: <1294220650.2016.197.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 23:54 -0500, Nelson Elhage wrote:
> Hi,
> 
> I've found a bug where, on CONFIG_RT_GROUP_SCHED systems, adding the kthreadd
> task to a cgroup with cpu.rt_runtime_us = 0 (as some cgroup configuration
> scripts do, when they move all processes into a default cgroup), can result in
> deadlocks in the kernel.

IMHO its a bug to move kthreadd into a cgroup. Simply don't do that.


