Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab2CZGbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 02:31:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab2CZGbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 02:31:45 -0400
Date: Mon, 26 Mar 2012 08:31:48 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC dontapply] kvm_para: add mmio word store hypercall
Message-ID: <20120326063148.GA27952@redhat.com>
References: <20120325220518.GA27879@redhat.com>
 <4F6FA972.9050103@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6FA972.9050103@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2012 at 04:25:38PM -0700, H. Peter Anvin wrote:
> On 03/25/2012 03:05 PM, Michael S. Tsirkin wrote:
> > We face a dilemma: IO mapped addresses are legacy,
> > so, for example, PCI express bridges waste 4K
> > of this space for each link, in effect limiting us
> > to 16 devices using this space.
> 
> That is *only* if they are physical devices on PCIe links.  For virtual
> devices you have no such limitation.

Why don't we? We emulate pci express with exact same limitations
for virtual and physical devices.

>  What is the problem again?
> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
