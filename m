Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab2IURrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:47:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345Ab2IURrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:47:33 -0400
Date: Fri, 21 Sep 2012 14:47:05 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        QEMU-devel <qemu-devel@nongnu.org>, KVM <kvm@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] Revert
 "mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix"
Message-ID: <20120921174705.GB6665@optiplex.redhat.com>
References: <1348224383-1499-1-git-send-email-mgorman@suse.de>
 <1348224383-1499-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348224383-1499-3-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 11:46:16AM +0100, Mel Gorman wrote:
> This reverts
> mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix
> as it is replaced by a later patch in the series.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Rafael Aquini <aquini@redhat.com>

