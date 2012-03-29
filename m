Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158Ab2C2WTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:19:36 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:44631
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759407Ab2C2WT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:19:28 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzzz2fh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F74DFDC.6060904@am.sony.com>
Date: Thu, 29 Mar 2012 15:19:08 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Daniel Walker <dwalker@fifo99.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: Re: [RFC] Android Logger vs. Shared Memory FIGHT!
References: <20120328210631.GB2297@fifo99.com>	<20120329145055.GE13912@fifo99.com>	<4F748CF6.4010205@am.sony.com>	<20120329175209.GE16476@fifo99.com> <20120329195007.07d53db7@pyramind.ukuu.org.uk>
In-Reply-To: <20120329195007.07d53db7@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 11:50 AM, Alan Cox wrote:
> The question is whether you are trying to record data for analysis in a
> hostile environment or you are trying to do useful debugging. If your
> apps are non hostile then PR_SET_NAME is actually useful in logging to
> split apart different executions of the same daemon.
> 
> The Android logger has no security model of any real kind so it's clearly
> about the debug side. In that case the PID lets you correlate with other
> logs, the comm data might be useful.

The current model has limited security, other than being in the kernel
and thus harder to corrupt (but still subject to DOS attacks
via overruning the log).

I think the envisioned security issues are more about preventing
access to application logs which might reveal sensitive information
(due to un-careful logging), than about analysing a hostile
environment.  But if it can be made harder for a bad program to
cover it's tracks, that would be nice.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

