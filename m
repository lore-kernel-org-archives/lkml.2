Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab2GSUaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 16:30:30 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57533 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2GSUa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 16:30:26 -0400
Date: Thu, 19 Jul 2012 15:30:17 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/34] vmscan: add shrink_slab tracepoints
Message-ID: <20120719203017.GC19392@burratino>
References: <1342708604-26540-1-git-send-email-mgorman@suse.de>
 <1342708604-26540-7-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342708604-26540-7-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:

> From: Dave Chinner <dchinner@redhat.com>
>
> commit 095760730c1047c69159ce88021a7fa3833502c8 upstream.
>
> Stable note: Not tracked in Bugzilla. This is a diagnostic patch that
> 	was part of a series addressing excessive slab shrinking after
> 	GFP_NOFS failures. There is detailed information on the series'
> 	motivation at https://lkml.org/lkml/2011/6/2/42 .

Thanks.  Why would we want this particular patch in stable@?  It
doesn't sound like it fixes a serious issue.

Curious,
Jonathan
