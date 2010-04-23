Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab0DWPix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:38:53 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:58864
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757642Ab0DWPiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:38:50 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lzz1202hzz6ff19hz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L1C64G-01-D98-02
X-M-MSG: 
Date: Fri, 23 Apr 2010 17:38:39 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: John Villalovos <sodarock@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, stable@kernel.org
Subject: Re: [PATCH] oprofile: remove double ring buffering
Message-ID: <20100423153839.GM6450@erda.amd.com>
References: <20100401011725.GA27567@basil.fritz.box>
 <20100401190205.GD6027@erda.amd.com>
 <m2h5e61b72f1004220733n65451418p7c321f07eb5d6b58@mail.gmail.com>
 <20100422160411.cfcae4e1.akpm@linux-foundation.org>
 <20100423090045.GI6450@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100423090045.GI6450@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Apr 2010 15:38:39.0366 (UTC) FILETIME=[0BA74260:01CAE2FB]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.04.10 11:00:45, Robert Richter wrote:
> I just make my tree ready for v2.6.35 and will put it in there.
> 
> The patch looks good, will run some tests.

The patch is now in the oprofile tree. Sorry for this late response.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

