Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab2B2Om7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:42:59 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42699 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab2B2Om6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:42:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.52.70.167 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <87ty29ew8h.fsf@linux.vnet.ibm.com>
References: <1330280398-27956-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20120227151135.7d4076c6.akpm@linux-foundation.org>
	<87ipirclhe.fsf@linux.vnet.ibm.com>
	<CAJd=RBA05LqrUohAfO43ywZR_xwi4KygpzZP2zun=taKTLCvnQ@mail.gmail.com>
	<87ty29ew8h.fsf@linux.vnet.ibm.com>
Date: Wed, 29 Feb 2012 22:42:57 +0800
Message-ID: <CAJd=RBA+7Hvwxz4kr9_bx0q4AqzEkaUo4pLnv-scGCeVB5puPg@mail.gmail.com>
Subject: Re: [PATCH] hugetlbfs: Add new rw_semaphore to fix truncate/read race
From: Hillf Danton <dhillf@gmail.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, hughd@google.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 7:04 PM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> I guess we need to closely look at the patch with respect to end-of-file

Feel free to correct Hillf:)

> condition. I will also try to get some testing with the patch.
>
Look forward to seeing test results.

Best regards
-hd
