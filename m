Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab0I1Oa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:30:27 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:12890
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754633Ab0I1OaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:30:25 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zzbb2cK98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9GO9T-02-BFT-02
X-M-MSG: 
Date: Tue, 28 Sep 2010 16:29:55 +0200
From: Robert Richter <robert.richter@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 3/7] x86, NMI, Rename memory parity error to PCI
 SERR error
Message-ID: <20100928142955.GB13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-3-git-send-email-ying.huang@intel.com>
 <20100927080106.GA32222@erda.amd.com>
 <1285576760.20791.70.camel@yhuang-dev>
 <20100927090056.GJ13563@erda.amd.com>
 <20100927153315.GB26290@redhat.com>
 <20100927164502.GS13563@erda.amd.com>
 <1285637617.20791.146.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285637617.20791.146.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.09.10 21:33:37, Huang Ying wrote:

> I suggest to
> print the reason byte only if (!(reason & 0xc0) && reason), where the
> reason is really unknown.

Why make it this complex for an error message?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

