Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030312Ab2CIWoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 17:44:55 -0500
Received: from home.keithp.com ([63.227.221.253]:33358 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755803Ab2CIWoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 17:44:54 -0500
From: Keith Packard <keithp@keithp.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Yang Bai <hamo.by@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>, kernel@tesarici.cz,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: inode->i_wb_list corruption.
In-Reply-To: <20120309201934.GN17489@zod.bos.redhat.com>
References: <20120306185137.GA15881@redhat.com> <20120306210307.GC8781@quack.suse.cz> <20120307072608.GA24087@localhost> <20120307104240.GB18658@quack.suse.cz> <CAO_0yfNt2jgiTPZn5NkwBAjQZtk+377gG71d6QOuXQrDHjdkEg@mail.gmail.com> <20120309145713.GA21543@redhat.com> <20120309151951.GA30160@redhat.com> <CAO_0yfMYOOTvRg9=8_eYP09o0BpzSEk=8vqgNk_vV_u3-biAYA@mail.gmail.com> <20120309180015.GA3862@redhat.com> <868vj97d20.fsf@sumi.keithp.com> <20120309201934.GN17489@zod.bos.redhat.com>
User-Agent: Notmuch/0.11.1 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 09 Mar 2012 14:44:49 -0800
Message-ID: <861up175su.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<#part sign=pgpmime>
On Fri, 9 Mar 2012 15:19:34 -0500, Josh Boyer <jwboyer@redhat.com> wrote:

> Is the VT-d issue something in the hardware itself, or do you mean if
> you have it enabled in the kernel?  We've had the intel IOMMU disabled
> by default in the Fedora kernels for a while now.  At least since before
> 3.2 was released.

I don't know for sure; David Woodhouse gave a scary presentation
yesterday that makes me unsure of what happens when IOMMU is disabled in
the kernel, given that much of the hardware is setup by the BIOS.

-- 
keith.packard@intel.com
