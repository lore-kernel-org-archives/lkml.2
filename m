Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab2GSWHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 18:07:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63102 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab2GSWHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 18:07:30 -0400
Date: Thu, 19 Jul 2012 17:07:21 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/34] vmscan: add shrink_slab tracepoints
Message-ID: <20120719220721.GE19392@burratino>
References: <1342708604-26540-1-git-send-email-mgorman@suse.de>
 <1342708604-26540-7-git-send-email-mgorman@suse.de>
 <20120719203017.GC19392@burratino>
 <20120719220411.GZ9222@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120719220411.GZ9222@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On Thu, Jul 19, 2012 at 03:30:17PM -0500, Jonathan Nieder wrote:

>> It doesn't sound like it fixes a serious issue.
>
> You're right, it doesn't. There are a few patches in this series that
> were applied because they made other patches easier to apply and this is
> one of them.  I should have noted this properly. Unlike other patches of
> this type in the series, this particular one would have been easy to work
> around. How about this as an updated note or would you prefer it was
> dropped entirely?

Some of the other patches of this type made sense, but I'd personally
prefer if this one was dropped, yes.  Though I am just a nobody that
reads patches rather than one of the relevant people. ;-)

Thanks,
Jonathan
