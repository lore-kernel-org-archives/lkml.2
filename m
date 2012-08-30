Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab2H3VmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:42:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab2H3VmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:42:21 -0400
Message-ID: <503FDE96.3040702@redhat.com>
Date: Thu, 30 Aug 2012 17:43:50 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michel Lespinasse <walken@google.com>, peterz@infradead.org,
        vrajesh@umich.edu, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 0/5] rbtree based interval tree as a prio_tree replacement
References: <1344324343-3817-1-git-send-email-walken@google.com> <20120830143401.be06d61b.akpm@linux-foundation.org>
In-Reply-To: <20120830143401.be06d61b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2012 05:34 PM, Andrew Morton wrote:

> It would good to have solid acknowledgement from Rik that this approach
> does indeed suit his pending vma changes.

It does. Michel's rbtree rework is exactly what I need.

I do not need the interval tree bits, but the faster
augmented rbtree is required for my vma changes to
no longer have the performance regression Johannes
measured with a kernel build.


