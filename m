Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab1D0ARi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 20:17:38 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:18879
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561Ab1D0ARh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 20:17:37 -0400
X-SpamScore: -29
X-BigFish: VPS-29(z21eRzbb2dK9371O1432N98dKzz1202hzz8275dhz2fh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4DB76088.2070306@am.sony.com>
Date: Tue, 26 Apr 2011 17:17:12 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] [0/106] 2.6.35.13 longterm review
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2011 02:12 PM, Andi Kleen wrote:
> 
> This is the start of the longterm review cycle for the 2.6.35.12 release.
> There are a large number of patches in this series, all will be posted as a 
> response to this one.  If anyone has any issues with these being applied, 
> please let me know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
> 
> The full quilt queue can be found at
> git://git.kernel.org/pub/scm/linux/kernel/git/longterm/longterm-queue-2.6.35
> 
> Responses should be made within 48 hours.

I tested the 2.6.35.13 patches on 4 development boards (on 4 architectures: x86,
ppc, mips and ARM), and found no problems.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

