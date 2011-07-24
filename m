Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab1GXQmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 12:42:42 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:56033 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab1GXQmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 12:42:39 -0400
Subject: Re: [ANNOUNCE] 3.0-rt3
From: hermann <brummer-@web.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Darren Hart <dvhart@linux.intel.com>
In-Reply-To: <alpine.LFD.2.02.1107241807390.3136@ionos>
References: <alpine.LFD.2.02.1107241223560.2702@ionos>
	 <4E2C2ED6.4040904@gmail.com>  <alpine.LFD.2.02.1107241807390.3136@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Jul 2011 18:42:36 +0200
Message-ID: <1311525756.2276.6.camel@box>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+l33uDjD85PijTZjj5aqyoxEIY3S9adY/45Gid
	BvNaFQvTKT4PEhGp3Zf8P89Vyxqhpvh9R0z2FCC2mf+Y7U4JIt
	vuG2t94ss=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 schrieb Thomas Gleixner:

> Dear RT Folks,
> 
> I'm pleased to announce the 3.0-rt3 release.
> 
> Changes versus 3.0-rt2:
> 
>   * Fix earlyprintk really
> 

Hi

I still have some trouble with rt1 - rt3. 
During boot, the kernel is absolutely silent, sometimes it hangs on boot,
sometimes it hangs on login, sometimes it freeze without any known reason 
during session (no heavy load or some thing like that).
I cant find any meaningful log, so I just can report it as it is here.
rc7-rt0 works very well here, I build 3.0-rt1 - rt3 with the same config 
then rt0.

regards
hermann

