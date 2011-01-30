Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab1A3CZp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 21:25:45 -0500
Received: from mga03.intel.com ([143.182.124.21]:14967 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab1A3CZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 21:25:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,398,1291622400"; 
   d="scan'208";a="381677946"
Date: Sun, 30 Jan 2011 10:25:41 +0800
From: Yin Kangkai <kangkai.yin@linux.intel.com>
To: Stanislav Brabec <sbrabec@suse.cz>
Cc: linux-serial <linux-serial@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Deepak Saxena <dsaxena@laptop.org>,
        Jason Wang <jason77.wang@gmail.com>, Daniel Drake <dsd@laptop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] serial-core: reset the console speed on resume
Message-ID: <20110130022541.GJ30650@kai-debian>
References: <20110125104302.GM3315@kai-debian>
 <1296346859.5397.29.camel@utx.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296346859.5397.29.camel@utx.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-30, 01:20 +0100, Stanislav Brabec wrote:
> Yin Kangkai wrote on Tue 25 Jan 2011 at 18:43 +0800:
> 
> > On some platforms, we need to restore the console speed on resume even
> > it was not suspended (no_console_suspend), and on others we don't have
> > to do that.
> > 
> > So don't care about the "console_suspend_enabled" and unconditionally
> > reset the console speed if it is a console.
> 
> Well, there is currently another breakage on Zaurus. But it improves the
> situation.
> (Note: Your patch has bad file path. I'll agree with such change after
> this fix.)

OK, I was based on .37 stable kernel. Will base on linus tree and
resend the patch right away. Thanks.

> Test report on Zaurus
> (serial hardware itself is in undefined state after resume):
> 
>                                        before  after
> login:                                   OK     OK
> console:                               broken broken
> console + login:                         OK     OK
> console + no_console_suspend:          broken broken
> login + no_console_suspend:              OK     OK
> console + login + no_console_suspend:  broken   OK

Thanks for the test, Stanislav. Good to know it improves the
situation.

Regards,
Kangkai
