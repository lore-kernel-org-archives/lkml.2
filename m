Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab2GONGe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 09:06:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab2GONG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 09:06:27 -0400
Message-ID: <5002C03C.2030304@redhat.com>
Date: Sun, 15 Jul 2012 16:06:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gleb@redhat.com
Subject: Re: [PATCH 0/3] make KVM PV use apic through APIs
References: <cover.1342356186.git.mst@redhat.com>
In-Reply-To: <cover.1342356186.git.mst@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2012 03:56 PM, Michael S. Tsirkin wrote:
> KVM PV EOI optimization overrides eoi_write apic op with its own
> version. at Ingo's suggestion, add an API for this and switch kvm to use
> it, to avoid meddling with core x86 apic driver data structures
> directly.
> 
> Ingo, could you please review and let us know whether this
> matches what you had in mind?
> 
> This patchset is on top of kvm/next since it touches some
> of the code modified in that tree (and patch 3 reverts a commit
> in that tree). Could x86 some maintainers pls ACK merging this patchset
> through the kvm tree?
> 

Looks okay to me.


-- 
error compiling committee.c: too many arguments to function


