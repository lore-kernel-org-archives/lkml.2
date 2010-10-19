Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab0JSQ2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:28:10 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:18200
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753837Ab0JSQ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:28:08 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK1432N98dN4015Lzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3extmailp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LAJPQI-01-946-02
X-M-MSG: 
Date: Tue, 19 Oct 2010 18:23:27 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>
Subject: Re: [PATCH 5/5] x86, NMI: Remove do_nmi_callback logic
Message-ID: <20101019162327.GT5969@erda.amd.com>
References: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
 <1287195738-3136-6-git-send-email-dzickus@redhat.com>
 <20101019150303.GQ5969@erda.amd.com>
 <20101019160158.GM4140@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101019160158.GM4140@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.10.10 12:01:58, Don Zickus wrote:
> On Tue, Oct 19, 2010 at 05:03:03PM +0200, Robert Richter wrote:
> > > +++ b/arch/x86/kernel/traps.c
> > > @@ -83,6 +83,8 @@ EXPORT_SYMBOL_GPL(used_vectors);
> > >  
> > >  static int ignore_nmis;
> > >  
> > > +int unknown_nmi_panic;
> > 
> > I didn't apply the patches, so I am not really sure, but I think this
> > could be static now.
> 
> It is used in kernel/sysctl.c so I don't think it can.

Ah, ok. Was only looking in arch/x86.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

