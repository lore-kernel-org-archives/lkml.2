Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2DOLh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 07:37:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:43302 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab2DOLhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 07:37:55 -0400
Message-ID: <1334489838.28150.4.camel@twins>
Subject: Re: [Lsf] [RFC] writeback and cgroup
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jan Kara <jack@suse.cz>, ctalbott@google.com, rni@google.com,
        andrea@betterlinux.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, lsf@lists.linux-foundation.org,
        linux-mm@kvack.org, jmoyer@redhat.com, lizefan@huawei.com,
        cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Sun, 15 Apr 2012 13:37:18 +0200
In-Reply-To: <20120412203719.GL2207@redhat.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
	 <20120404145134.GC12676@redhat.com> <20120407080027.GA2584@quack.suse.cz>
	 <20120410180653.GJ21801@redhat.com> <20120410210505.GE4936@quack.suse.cz>
	 <20120410212041.GP21801@redhat.com> <20120410222425.GF4936@quack.suse.cz>
	 <20120411154005.GD16692@redhat.com> <20120411192231.GF16008@quack.suse.cz>
	 <20120412203719.GL2207@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-12 at 16:37 -0400, Vivek Goyal wrote:
> If yes, how does one map a filesystem's bdi we want to put rules on?
> 
/proc/self/mountinfo has the required bits
