Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab1ITTFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 15:05:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab1ITTFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 15:05:17 -0400
Message-ID: <4E78E3DF.1070501@redhat.com>
Date: Tue, 20 Sep 2011 15:05:03 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Wolf <mjwolf@us.ibm.com>
Subject: Re: [PATCH 1/8] page_referenced: replace vm_flags parameter with
 struct pr_info
References: <1316230753-8693-1-git-send-email-walken@google.com> <1316230753-8693-2-git-send-email-walken@google.com>
In-Reply-To: <1316230753-8693-2-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2011 11:39 PM, Michel Lespinasse wrote:
> Introduce struct pr_info, passed into page_referenced() family of functions,
> to represent information about the pte references that have been found for
> that page. Currently contains the vm_flags information as well as
> a PR_REFERENCED flag. The idea is to make it easy to extend the API
> with new flags.
>
>
> Signed-off-by: Michel Lespinasse<walken@google.com>

I have to agree with Joe's suggested name change.

Other than that, this patch looks good (will ack the next version).
