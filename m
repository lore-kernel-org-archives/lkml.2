Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab1LRQEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 11:04:15 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:14951
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085Ab1LRQEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 11:04:13 -0500
X-SpamScore: -3
X-BigFish: VPS-3(zz98dKzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LWEPYQ-02-0ZH-02
X-M-MSG: 
Date: Sun, 18 Dec 2011 17:04:01 +0100
From: Robert Richter <robert.richter@amd.com>
To: Greg KH <gregkh@suse.de>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Greg KH <greg@kroah.com>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <alan@lxorguk.ukuu.org.uk>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        John Lumby <johnlumby@hotmail.com>,
        Maynard Johnson <maynardj@us.ibm.com>
Subject: Re: [13/16] [PATCH 2/3] oprofile, x86: Fix nmi-unsafe callgraph
 support
Message-ID: <20111218160401.GA16765@erda.amd.com>
References: <20111216205049.GA28030@kroah.com>
 <20111216205043.465306786@clark.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111216205043.465306786@clark.kroah.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.12.11 12:49:46, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.

Looks like the [PATCH ...] should be stripped in the subject line.

Same with

 [14/16] [PATCH 3/3] oprofile, x86: Fix crash when unloading module (timer mode)

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

