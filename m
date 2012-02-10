Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759162Ab2BJLbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 06:31:50 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:26510 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab2BJLbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 06:31:48 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz1432N98dK4015Lzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ6DCV-02-2UN-02
X-M-MSG: 
Date: Fri, 10 Feb 2012 12:31:40 +0100
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] perf tools: More fixes and updates
Message-ID: <20120210113140.GL16322@erda.amd.com>
References: <1323966762-8574-1-git-send-email-robert.richter@amd.com>
 <20120131155154.GH16322@erda.amd.com>
 <20120202201402.GG8566@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120202201402.GG8566@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.02.12 18:14:02, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jan 31, 2012 at 04:51:54PM +0100, Robert Richter escreveu:
> > On 15.12.11 17:32:38, Robert Richter wrote:
> > > Some more fixes and updates for perf tools.
> > > 
> > > Robert Richter (4):

> > >   perf tools: Moving code in header.c
> > >   perf tools: Factor out feature op to process header sections

> Agreed, I applied both to my local repo, after some testing and
> reviewing some more patches I'll push it to Ingo, thanks,

Arnaldo, the two above are not yet applied. Should I drop them?

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

