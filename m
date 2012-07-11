Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab2GKJ5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 05:57:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756995Ab2GKJ46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 05:56:58 -0400
Message-ID: <4FFD4DE5.6080409@redhat.com>
Date: Wed, 11 Jul 2012 12:56:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: mtosatti@redhat.com, mst@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH] kvm: Fix device assignment threaded irq handler
References: <20120709165152.30002.32440.stgit@bling.home>
In-Reply-To: <20120709165152.30002.32440.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 07:53 PM, Alex Williamson wrote:
> The kernel no longer allows us to pass NULL for the hard handler
> without also specifying IRQF_ONESHOT.  IRQF_ONESHOT imposes latency
> in the exit path that we don't need for MSI interrupts.  Long term
> we'd like to inject these interrupts from the hard handler when
> possible.  In the short term, we can create dummy hard handlers
> that return us to the previous behavior.  Credit to Michael for
> original patch.
> 
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=43328
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> Patch against kvm/master for v3.5
> 


Thanks, queued for 3.5.


-- 
error compiling committee.c: too many arguments to function


