Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab2CYXZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 19:25:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45371 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932323Ab2CYXZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 19:25:58 -0400
Message-ID: <4F6FA972.9050103@zytor.com>
Date: Sun, 25 Mar 2012 16:25:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC dontapply] kvm_para: add mmio word store hypercall
References: <20120325220518.GA27879@redhat.com>
In-Reply-To: <20120325220518.GA27879@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2012 03:05 PM, Michael S. Tsirkin wrote:
> We face a dilemma: IO mapped addresses are legacy,
> so, for example, PCI express bridges waste 4K
> of this space for each link, in effect limiting us
> to 16 devices using this space.

That is *only* if they are physical devices on PCIe links.  For virtual
devices you have no such limitation.  What is the problem again?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

