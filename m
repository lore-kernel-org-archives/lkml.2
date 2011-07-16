Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab1GPQ22 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 12:28:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42125 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab1GPQ22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 12:28:28 -0400
Date: Sat, 16 Jul 2011 17:28:06 +0100
From: Matthew Garrett <mjg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jwilson@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH] Replace a function call chain of
 kmsg_dump(KMSG_DUMP_KEXEC) with static function calls
Message-ID: <20110716162805.GA13127@srcf.ucam.org>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C17AAE59A@USINDEVS01.corp.hds.com>
 <m14o2mjj5l.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14o2mjj5l.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 09:16:06AM -0700, Eric W. Biederman wrote:

> What is going on with EFI support?  We are still making efi calls in
> virtual mode, and we don't have the one unified identity mapped physical
> page table that hpa and I think others were working a while back.  Even
> if because of bugs we need to transition EFI to virtual mode we can
> still set physical to virtual so we don't have to deal with the nonsense.

No, we can't. It doesn't work.

> Can we please make our EFI support ask the minimal from EFI before
> adding lots more to it?

No.

> Am I wrong in thinking that the core motivation behind this patch is
> that our EFI support sucks and thus kdump on EFI does not work on some
> platforms?

Yes, you are.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
