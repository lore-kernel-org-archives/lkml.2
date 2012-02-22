Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab2BVNGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:06:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:53742 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab2BVNGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:06:34 -0500
Message-ID: <1329915987.24994.5.camel@twins>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
From: Peter Zijlstra <peterz@infradead.org>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Date: Wed, 22 Feb 2012 14:06:27 +0100
In-Reply-To: <20120204110817.30e1a4c62754f074a8a5064d@gmail.com>
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws>
	 <20120204110817.30e1a4c62754f074a8a5064d@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-04 at 11:08 +0900, Takuya Yoshikawa wrote:
> The latter needs a fundamental change:  I heard (from Avi) that we can
> change mmu_lock to mutex_lock if mmu_notifier becomes preemptible.
> 
> So I was planning to restart this work when Peter's
>         "mm: Preemptibility"
>         http://lkml.org/lkml/2011/4/1/141
> gets finished. 


That got merged a while ago:

# git describe --contains d16dfc550f5326a4000f3322582a7c05dec91d7a --match "v*"
v3.0-rc1~275

While I still need to get back to unifying mmu_gather across
architectures the whole thing is currently preemptible.
