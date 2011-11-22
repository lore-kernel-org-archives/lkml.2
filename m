Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab1KVNE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 08:04:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63034 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab1KVNE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 08:04:28 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1111211413460.1879@sister.anvils>
References: <CAJd=RBDP_z68Ewvw_O_dMxOnE0=weXqt+1FQy85_n76HAEdFHg@mail.gmail.com>
	<alpine.LSU.2.00.1111201923330.1806@sister.anvils>
	<CAJd=RBBa-ZoZ3GhYQ-aM=TJ9Zw6ZSu177PWw+s8+zyFnzyUV_w@mail.gmail.com>
	<alpine.LSU.2.00.1111211413460.1879@sister.anvils>
Date: Tue, 22 Nov 2011 21:04:26 +0800
Message-ID: <CAJd=RBD7OEmuP9HJS9eq2b5KFfNikf61Zi8+UkxQuD_88vRV4g@mail.gmail.com>
Subject: Re: [PATCH] ksm: use FAULT_FLAG_ALLOW_RETRY in breaking COW
From: Hillf Danton <dhillf@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 6:23 AM, Hugh Dickins <hughd@google.com> wrote:
> But what's the point in enlarging the kernel, adding code to make
> break_cow() look more complicated, when there's no way in which the
> addition can make an improvement?
>
Hello Hugh

Thanks for correcting me, there is no real point to complicate the function.

Hillf
