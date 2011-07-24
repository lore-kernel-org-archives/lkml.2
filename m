Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab1GXQoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 12:44:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:35833 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab1GXQoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 12:44:13 -0400
Date: Sun, 24 Jul 2011 18:44:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: hermann <brummer-@web.de>
cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [ANNOUNCE] 3.0-rt3
In-Reply-To: <1311525756.2276.6.camel@box>
Message-ID: <alpine.LFD.2.02.1107241843180.3136@ionos>
References: <alpine.LFD.2.02.1107241223560.2702@ionos>  <4E2C2ED6.4040904@gmail.com>  <alpine.LFD.2.02.1107241807390.3136@ionos> <1311525756.2276.6.camel@box>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jul 2011, hermann wrote:
> I still have some trouble with rt1 - rt3. 
> During boot, the kernel is absolutely silent, sometimes it hangs on boot,
> sometimes it hangs on login, sometimes it freeze without any known reason 
> during session (no heavy load or some thing like that).
> I cant find any meaningful log, so I just can report it as it is here.
> rc7-rt0 works very well here, I build 3.0-rt1 - rt3 with the same config 
> then rt0.

Hmm, can you please provide your .config and a demsg from a rc7-rt0 boot?

Thanks,

	tglx
