Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab2ITS4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:56:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527Ab2ITSzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:55:03 -0400
Message-ID: <505B6680.2000609@redhat.com>
Date: Thu, 20 Sep 2012 14:54:56 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Avi Kivity <avi@redhat.com>, QEMU-devel <qemu-devel@nongnu.org>,
        KVM <kvm@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] Revert "mm: have order > 0 compaction start off where
 it left"
References: <1348149875-29678-1-git-send-email-mgorman@suse.de> <1348149875-29678-5-git-send-email-mgorman@suse.de>
In-Reply-To: <1348149875-29678-5-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 10:04 AM, Mel Gorman wrote:
> This reverts commit 7db8889a (mm: have order > 0 compaction start off
> where it left) and commit de74f1cc (mm: have order > 0 compaction start
> near a pageblock with free pages). These patches were a good idea and
> tests confirmed that they massively reduced the amount of scanning but
> the implementation is complex and tricky to understand. A later patch
> will cache what pageblocks should be skipped and reimplements the
> concept of compact_cached_free_pfn on top for both migration and
> free scanners.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Sure, it makes your next patches easier...

Acked-by: Rik van Riel <riel@redhat.com>

