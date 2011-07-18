Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab1GRLny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 07:43:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab1GRLny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 07:43:54 -0400
Date: Mon, 18 Jul 2011 07:43:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jwilson@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH] Replace a function call chain of
 kmsg_dump(KMSG_DUMP_KEXEC) with static function calls
Message-ID: <20110718114334.GA31986@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C17AAE59A@USINDEVS01.corp.hds.com>
 <m14o2mjj5l.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14o2mjj5l.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 09:16:06AM -0700, Eric W. Biederman wrote:

[..]
> Am I wrong in thinking that the core motivation behind this patch is
> that our EFI support sucks and thus kdump on EFI does not work on some
> platforms?

One of the arguments seems is that kdump might not work 100% of the
time and saving kernel messages atleast gets some information out
reliably.

I think being able to save dmesg to NVRAM, in general sounds good to
me (if done in a relatively clean manner). Especially if we can get
rid of code taking locks and code path executed after crash is not
tool long and relatively easy to audit.

Thanks
Vivek
