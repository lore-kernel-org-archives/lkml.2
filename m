Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935229Ab2JXQe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:34:27 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42879 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935210Ab2JXQeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:34:24 -0400
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Kent Overstreet <koverstreet@google.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, martin.petersen@oracle.com
Subject: Re: [PATCH v4 1/2] block: Fix a buffer overrun in bio_integrity_split()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
	<1350331769-14856-28-git-send-email-koverstreet@google.com>
	<20121019203015.GS13370@google.com> <20121022153907.GC3401@redhat.com>
Date: Wed, 24 Oct 2012 12:34:14 -0400
In-Reply-To: <20121022153907.GC3401@redhat.com> (Vivek Goyal's message of
	"Mon, 22 Oct 2012 11:39:07 -0400")
Message-ID: <yq1mwzbbzi1.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:

Vivek> Initially he had reordered the bio_pair fields but there were
Vivek> couple of issues. We could not assume that there is no padding
Vivek> between fields and secondly some of the initializtion of looked
Vivek> plain ugly.

Vivek> IMHO, introduction of bip_vec to fix this issue is small and
Vivek> cleaner then reordering fields.

I agree.

-- 
Martin K. Petersen	Oracle Linux Engineering
