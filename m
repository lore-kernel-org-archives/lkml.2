Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1APPfN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 10:35:13 -0500
Received: from 8bytes.org ([88.198.83.132]:39488 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab1APPfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 10:35:08 -0500
Date: Sun, 16 Jan 2011 16:35:06 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2 v2] perf-kvm support for SVM
Message-ID: <20110116153506.GI6376@8bytes.org>
References: <1295019902-31339-1-git-send-email-joerg.roedel@amd.com> <4D32CD45.3090503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D32CD45.3090503@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 12:49:41PM +0200, Avi Kivity wrote:
> On 01/14/2011 05:45 PM, Joerg Roedel wrote:

>> here is the reworked version of the patch-set. Only patch 1/2 has
>> changed and now contains the real fix for the crashes that were seen and
>> has an updated log message.
>>
>
> Thanks, applied.  2.6.37 and earlier aren't affected, yes?  So I'm  
> queuing it for 2.6.38 only.

I think the problem is there since KVM has lazy state switching. So the
fix in patch 1 should make it in all currently maintained stable-trees.

	Joerg

