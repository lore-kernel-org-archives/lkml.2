Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab2B2NYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 08:24:21 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:17589 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755505Ab2B2NYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 08:24:19 -0500
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2dI9371I1432N98dKzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M05P8A-02-2SX-02
X-M-MSG: 
Date: Wed, 29 Feb 2012 14:24:10 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: David Ahern <dsahern@gmail.com>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <joro@8bytes.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>, Gleb Natapov <gleb@redhat.com>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH] perf/x86: Fix HO/GO counting with SVM disabled
Message-ID: <20120229132410.GB10684@amd.com>
References: <20120227182325.GA12302@8bytes.org>
 <1330444544-15665-1-git-send-email-joerg.roedel@amd.com>
 <4F4D0DD6.9030302@redhat.com>
 <4F4D10A9.5010707@gmail.com>
 <4F4D111A.8020001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F4D111A.8020001@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 07:38:34PM +0200, Avi Kivity wrote:
> On 02/28/2012 07:36 PM, David Ahern wrote:

> > I was to suggest the reverse: since this patch addesses an AMD bug,
> > why not push those functions into perf_event_amd.c and make them
> > dependent on CONFIG_CPU_SUP_AMD as well.
> 
> It depends on which direction you expect the code to grow.  These hooks
> seem reasonable, so I think they should be generic.

Okay, I am fine with both directions. But since this patch is a fix in
the first place I make it more AMD specific for now. If we need this as
a generic feature it can easily be changed back.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

