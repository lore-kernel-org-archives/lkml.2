Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab2GYMuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:50:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932889Ab2GYMuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:50:19 -0400
Message-ID: <500FEB81.4020008@redhat.com>
Date: Wed, 25 Jul 2012 14:50:09 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org,
        JBottomley@parallels.com, stefanha@linux.vnet.ibm.com,
        mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: virtio-scsi: Fix address translation failure
 of HighMem pages used by sg list
References: <1343218390-24310-1-git-send-email-senwang@linux.vnet.ibm.com> <500FE7C9.3000703@redhat.com> <500FEAC7.2050803@panasas.com>
In-Reply-To: <500FEAC7.2050803@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/07/2012 14:47, Boaz Harrosh ha scritto:
> 
> NACK-by: Boaz Harrosh
> 
> 
> Apart from the HighMem pages problem, where in previous sg_set_buf()
> code was the marker copied? It was not because it is not needed because
> the allocation of sg took care of that. For example in 64bit the is no
> bugs, right?
> 
> If there was a destination sg_list termination bug, it should be fixed
> as a separate patch from this "HighMem pages problem". But I bet if
> you inspect the code carefully there isn't such a bug.

Hmm, we're talking past each other.  Let's sort it out in the v1 thread.
 Sen, please hold up the patch for a moment.

Paolo

