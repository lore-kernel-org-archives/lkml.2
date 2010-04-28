Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab0D1Q77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 12:59:59 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:31128
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751337Ab0D1Q75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 12:59:57 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zz98dN936eM62a3Lzz1202hzz6ff19h2ba5Mz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L1LJ7L-01-CND-02
X-M-MSG: 
Date: Wed, 28 Apr 2010 18:59:06 +0200
From: Robert Richter <robert.richter@amd.com>
To: Siarhei Siamashka <siarhei.siamashka@nokia.com>
CC: oprofile-list@lists.sourceforge.net,
       "Carmody Phil.2 (EXT-Ixonos/Helsinki)" <ext-phil.2.carmody@nokia.com>,
       "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] updates for oprofile
Message-ID: <20100428165906.GA21724@erda.amd.com>
References: <20100427152544.GA9063@pcarmody-desktop>
 <20100427174026.GR6450@erda.amd.com>
 <201004272047.52056.siarhei.siamashka@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201004272047.52056.siarhei.siamashka@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 Apr 2010 16:59:06.0790 (UTC) FILETIME=[1D167460:01CAE6F4]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.04.10 20:47:51, Siarhei Siamashka wrote:
> Isn't hrtimer callback function supposed to be only called from IRQ context
> after this cleanup: http://lwn.net/Articles/308545/ ?

Yes, the patch is upstream since v2.6.29. Thanks Siarhei.

I will add a null pointer check anyway.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

