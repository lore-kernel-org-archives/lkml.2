Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322Ab2FHORQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:17:16 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:22795
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932916Ab2FHOQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:16:58 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(z1823lz98dI9371I936eI1432Izz1202hzz8275dhz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5AYC3-02-6HK-02
X-M-MSG: 
Date: Fri, 8 Jun 2012 16:17:14 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Stephane Eranian <eranian@google.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Ingo Molnar <mingo@kernel.org>, <linux-kernel@vger.kernel.org>,
        <andi@firstfloor.org>, <mingo@elte.hu>, <ming.m.lin@intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120608141714.GE31359@aftab.osrc.amd.com>
References: <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
 <1339065932.23343.18.camel@twins>
 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
 <1339067757.23343.21.camel@twins>
 <20120608093513.GA22520@gmail.com>
 <1339149613.23343.52.camel@twins>
 <1339161972.2507.13.camel@laptop>
 <20120608135117.GB31359@aftab.osrc.amd.com>
 <1339163986.2507.19.camel@laptop>
 <CABPqkBSAO_7W_pN+uq0uy-vaciBEE57oNF9Q6s_o39SBVWbc3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABPqkBSAO_7W_pN+uq0uy-vaciBEE57oNF9Q6s_o39SBVWbc3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 04:03:38PM +0200, Stephane Eranian wrote:
> On Fri, Jun 8, 2012 at 3:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2012-06-08 at 15:51 +0200, Borislav Petkov wrote:
> >> Provided, of course, newer microcode versions means a
> >> higher version number.
> >
> > Fair enough, I assumed this.. is this true?
> >
> I would think so, otherwise it gets even messier!

Need to get Intel folk to say something here, hpa?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

