Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab0ERKSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 06:18:37 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:48701
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756181Ab0ERKSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 06:18:34 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz98dN936eM62a3Lzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L2M1XY-01-560-02
X-M-MSG: 
Date: Tue, 18 May 2010 12:18:04 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "acme@redhat.com" <acme@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mhiramat@redhat.com" <mhiramat@redhat.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:perf/core] perf probe: Don't compile CFI related code if
 elfutils is old
Message-ID: <20100518101803.GI21799@erda.amd.com>
References: <20100510171207.26029.97604.stgit@localhost6.localdomain6>
 <tip-7752f1b096e13991f20b59fd11ba73da3809d93c@git.kernel.org>
 <20100518093535.GF21799@erda.amd.com>
 <AANLkTilWR9fEWBOZLyvFcU6DR6i9aswpSRzFnlIiSoNm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTilWR9fEWBOZLyvFcU6DR6i9aswpSRzFnlIiSoNm@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.05.10 05:39:58, Stephane Eranian wrote:
> If I understand Masami's patch, you can still compile dwarf support
> in despite the lack of Dwarf_CFI.

I see, so the #if macros are effectively needed only for versions 138
to 141.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

