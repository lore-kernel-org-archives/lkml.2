Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab2GTPya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 11:54:30 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48870 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab2GTPy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 11:54:29 -0400
Date: Fri, 20 Jul 2012 10:54:17 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/34] vmscan: add shrink_slab tracepoints
Message-ID: <20120720155417.GA2885@burratino>
References: <1342708604-26540-1-git-send-email-mgorman@suse.de>
 <1342708604-26540-7-git-send-email-mgorman@suse.de>
 <20120719203017.GC19392@burratino>
 <20120719220411.GZ9222@suse.de>
 <20120719220721.GE19392@burratino>
 <20120720100623.GE9222@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120720100623.GE9222@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On Thu, Jul 19, 2012 at 05:07:21PM -0500, Jonathan Nieder wrote:

>> Some of the other patches of this type made sense, but I'd personally
>> prefer if this one was dropped, yes.  Though I am just a nobody that
>> reads patches rather than one of the relevant people. ;-)
>
> It's a valid point but I'm going to leave it in for now and see what the
> general opinion is.

Ok.  To be more precise, this patch has two properties that other patches
of the "make later patches easier to apply" class tend not to:

 * it introduces a significant functional change (adding tracepoints)
 * it would have been very easy to skip

Have fun, and sorry for not explaining my reasoning before.

Ciao,
Jonathan
