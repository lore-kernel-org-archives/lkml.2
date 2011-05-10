Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810Ab1EJO7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:59:16 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:29838
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932320Ab1EJO7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:59:14 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKZIY2-01-6KE-02
X-M-MSG: 
Date: Tue, 10 May 2011 16:59:02 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf, core: Introduce attrs to count in either host
 or guest mode
Message-ID: <20110510145902.GA30996@amd.com>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
 <1305038132-5080-2-git-send-email-joerg.roedel@amd.com>
 <1305038746.2914.94.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1305038746.2914.94.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 10:45:46AM -0400, Peter Zijlstra wrote:
> On Tue, 2011-05-10 at 16:35 +0200, Joerg Roedel wrote:
> > +       /* Can't exclude counting in guest and in host mode */
> > +       if (attr.exclude_host && attr.exclude_guest)
> > +               return -EINVAL;
> 
> Why not?

By definition the counter won't count at all. The hardware just ignores
the bits if they are both set. My rationale here was that it does not
makes sense to setup a counter and exclude guest and host mode.

	Joerg


