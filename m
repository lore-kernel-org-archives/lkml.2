Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab2DMUxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 16:53:31 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:6873 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755981Ab2DMUxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 16:53:23 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zzbb2dI1432N98dKzz1202hzz8275eha1495iz2fh668h839hd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F889228.8050301@am.sony.com>
Date: Fri, 13 Apr 2012 13:52:56 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.4-rc2-rt4
References: <alpine.LFD.2.02.1204131033240.2542@ionos>
In-Reply-To: <alpine.LFD.2.02.1204131033240.2542@ionos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/12 05:11, Thomas Gleixner wrote:
> Dear RT Folks,
> 
> I'm pleased to announce the 3.4-rc2-rt4 release.

< snip >

3.4-rc2-rt4 builds and boots on some ARM boards (PandaBoard, Realview) for:

  - SMP, PREEMPT_RT_FULL
  - SMP, PREEMPT_NONE
  - UP, PREEMPT_RT_FULL
  - UP, PREEMPT_NONE


A patch is required to resolve a mainline NULL pointer dereference on boot
of Realview.  The patch is in linux-next and should make it to Linus by the
end of this week.

The patch is available at http://marc.info/?l=linux-serial&m=133235774423240&w=2

-Frank

