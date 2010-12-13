Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab0LMJM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 04:12:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59999 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab0LMJM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 04:12:56 -0500
Date: Mon, 13 Dec 2010 10:12:54 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, mst@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] [104/223] KVM: Write protect memory after slot swap
Message-ID: <20101213091254.GA999@basil.fritz.box>
References: <201012131244.547034648@firstfloor.org>
 <20101212234644.B05DAB27BF@basil.firstfloor.org>
 <4D05DC98.40105@redhat.com>
 <044a861a2279c7e3e328c73e6694fbf3.squirrel@www.firstfloor.org>
 <4D05E096.6060307@redhat.com>
 <74ff92a8c4cf72e42e7559de72e77b52.squirrel@www.firstfloor.org>
 <4D05E2A5.8070204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D05E2A5.8070204@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - Greg rejects kvm patches (but not virtio etc) pointing submitters
> to the kvm maintainers
> - The kvm maintainers collect stable kvm patches and autotest them

As I understand this patch came in this way for .36
(I took it from .36-stable)

> - They then submit the patches to stable@

Do you want to do the autotest explicitely for .35 too and no automatic
backports and do the same procedure as for newer kernels?

I can do that, but you would need to do it for a long time.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
