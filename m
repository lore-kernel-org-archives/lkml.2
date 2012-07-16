Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab2GPJwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 05:52:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab2GPJwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 05:52:41 -0400
Message-ID: <5003E457.9040103@redhat.com>
Date: Mon, 16 Jul 2012 12:52:23 +0300
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

Applied to next, thanks.

-- 
error compiling committee.c: too many arguments to function


