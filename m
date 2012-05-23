Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab2EWUEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:04:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab2EWUET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:04:19 -0400
Message-ID: <4FBD4292.9020907@redhat.com>
Date: Wed, 23 May 2012 16:03:30 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Nathan Zimmer <nzimmer@sgi.com>
CC: Hugh Dickins <hughd@google.com>, Nick Piggin <npiggin@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] tmpfs not interleaving properly
References: <74F10842A85F514CA8D8C487E74474BB2C1597@P-EXMB1-DC21.corp.sgi.com>
In-Reply-To: <74F10842A85F514CA8D8C487E74474BB2C1597@P-EXMB1-DC21.corp.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 09:28 AM, Nathan Zimmer wrote:
>
> When tmpfs has the memory policy interleaved it always starts allocating at each file at node 0.
> When there are many small files the lower nodes fill up disproportionately.
> My proposed solution is to start a file at a randomly chosen node.
>
> Cc: Christoph Lameter<cl@linux.com>
> Cc: Nick Piggin<npiggin@gmail.com>
> Cc: Hugh Dickins<hughd@google.com>
> Cc: Lee Schermerhorn<lee.schermerhorn@hp.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Nathan T Zimmer<nzimmer@sgi.com>

Acked-by: Rik van Riel <riel@redhat.com>

