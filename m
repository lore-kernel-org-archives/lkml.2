Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab2DTR55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:57:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64085 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab2DTR54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:57:56 -0400
Date: Fri, 20 Apr 2012 10:57:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Mike Galbraith <mgalbraith@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Li Zefan <lizf@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
Message-ID: <20120420175751.GF32324@google.com>
References: <1333475906.7439.7.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333475906.7439.7.camel@marge.simpson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mike.

This is dragging out too long but can you please update the patch so
that both kthreadd and PF_THREAD_BOUND tasks are disallowed from !root
cgroups?

Thanks.

-- 
tejun
