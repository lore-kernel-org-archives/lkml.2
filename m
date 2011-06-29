Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab1F2MzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:55:24 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:33676
	"EHLO CH1EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755976Ab1F2MzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:55:18 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNJYJZ-01-LWD-02
X-M-MSG: 
Date: Wed, 29 Jun 2011 14:55:08 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Tejun Heo <tj@kernel.org>
CC: "Seidel, Conny" <Conny.Seidel@amd.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 32bit NUMA and fakeNUMA broken for AMD CPUs
Message-ID: <20110629125507.GQ478@escobedo.osrc.amd.com>
References: <20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110626102235.GC12200@mtj.dyndns.org>
 <20110626223807.47cef5c6.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110628174613.GP478@escobedo.osrc.amd.com>
 <20110629094451.GJ3386@htj.dyndns.org>
 <20110629123409.GL3386@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110629123409.GL3386@htj.dyndns.org>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 08:34:09AM -0400, Tejun Heo wrote:
> So, mminit_verify_page_links() detects it while the last 512MiB
> highmem chunk of node 0 is being initialized and freaks out.
> 
> We definitely need a safe guard to check NUMA node alignment and
> disable NUMA if it requires finer granuality than supported by the
> memory model.  If you use DISCONTIGMEM, which has 64MiB granuality,
> instead, it works, right?

I had DISCONTIGMEM enabled in the kernel config, it does not work.

Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

