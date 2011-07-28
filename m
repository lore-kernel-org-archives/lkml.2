Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab1G1Pxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:53:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45411 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab1G1Pxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:53:31 -0400
Date: Thu, 28 Jul 2011 08:52:45 -0700
From: Greg KH <gregkh@suse.de>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [stable-longterm] x86: HPET: Chose a paranoid safe value for the
 ETIME check
Message-ID: <20110728155245.GA22939@suse.de>
References: <alpine.LFD.2.00.1012131222420.2653@localhost6.localdomain6>
 <tip-f1c18071ad70e2a78ab31fc26a18fcfa954a05c6@git.kernel.org>
 <4E3180C9.4000601@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3180C9.4000601@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 07:31:21PM +0400, Konstantin Khlebnikov wrote:
> I think this v2.6.37-rc5-64-gf1c1807 and v2.6.36-rc4-167-g995bd3b should be merged into longterm/stable kernels.
> We also found the same bug in RHEL6 kernel. (nohz kernel stuck and wait for HPET wraparound)
> This HPET-bug really annoying, while fix is tiny.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
