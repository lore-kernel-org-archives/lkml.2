Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab1CAVrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:47:07 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:54971 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762Ab1CAVrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:47:05 -0500
Date: Tue, 1 Mar 2011 16:47:02 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] tpm_tis on Lenovo T410 broken in 2.6.38-rc6
Message-ID: <20110301214702.GB2959@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	James Morris <jmorris@namei.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <E1PuKHL-0000lw-RM@tytso-glaptop>
 <4D6CFA80.3020505@linux.vnet.ibm.com>
 <BD305A55-A581-4779-B5EA-084B186C903D@mit.edu>
 <4D6D65C4.5000602@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6D65C4.5000602@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 06:31:48PM -0300, Rajiv Andrade wrote:
> 
> Thanks for clarifying the context. Please add a
> 
> WARN_ON(duration<=0, "no duration for ordinal %x (duration_idx
> %d)", ordinal, duration_idx);

Data has been sent in another e-mail.

> as Linus suggested. Also please check if there's an IRQ assigned to the TPM on both scenarios:
> 
> cat /proc/interrupts | grep -i tpm

Unfortunately, I was off-line doing these tests (because I can't
connect to the company intranet :-P), so I did't see your e-mail.
I'll be able to reboot and collect this information later, but there's
Real Work I have to get done at this point....  I can tell you that in
my working configuration, both with 2.6.37 and with the latest Linus
tip with commit c4ff4b829e reverted, I have no interrupt assigned to
the TPM.

> and finally, before the revert, with the
> 9b29050f tpm_tis: Use timeouts returned from TPM
> commit applied:
> 
> cat /sys/devices/pnp0/00\:0*/timeouts

See above; I can get this information later, if it's really needed,
but unfortunately it's on the company laptop, and I have some real
work I need to get back to.  (I don't need network access while at
meetings, so I could run some tests before lunch; now the meetings are
done and I have to get back to coding.  :-)

						- Ted
