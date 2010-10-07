Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441Ab0JGMcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 08:32:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760402Ab0JGMcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 08:32:45 -0400
Message-ID: <4CADBDB1.9060608@redhat.com>
Date: Thu, 07 Oct 2010 14:31:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 04/12] Add memory slot versioning and use it to provide
 fast guest write interface
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-5-git-send-email-gleb@redhat.com>
In-Reply-To: <1286207794-16120-5-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/04/2010 05:56 PM, Gleb Natapov wrote:
> Keep track of memslots changes by keeping generation number in memslots
> structure. Provide kvm_write_guest_cached() function that skips
> gfn_to_hva() translation if memslots was not changed since previous
> invocation.

btw, this patch (and patch 5, and perhaps more) can be applied 
independently.  If you like, you can submit them before the patch set is 
complete to reduce your queue length.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

