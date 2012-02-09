Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab2BIP24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:28:56 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:3699
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757858Ab2BIP2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:28:55 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz179dN98dKzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ4TNX-02-6CK-02
X-M-MSG: 
Date: Thu, 9 Feb 2012 16:28:44 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jason Wang <jasowang@redhat.com>
Subject: Re: perf: record segfaults for cycles event when collecting data on
 a VM
Message-ID: <20120209152844.GQ22598@amd.com>
References: <4F32A907.6030505@gmail.com>
 <20120208174434.GI22598@amd.com>
 <4F32B680.3090502@gmail.com>
 <20120208175709.GK22598@amd.com>
 <20120209073024.GA18010@elte.hu>
 <20120209111451.GM22598@amd.com>
 <20120209133446.GD8830@elte.hu>
 <20120209143253.GP22598@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120209143253.GP22598@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 03:32:53PM +0100, Joerg Roedel wrote:
> Yeah, right. Guest samples may also show up intentionally when the event
> modifiers are used. So crashing on machine==NULL needs to be fixed.

Hmm, on the other hand, there is no way to specify guest symbol
information to the regular perf subcommands except for perf-kvm. Without
that information perf can not resolve any GUEST_KERNEL samples, so in
the end there is no point in setting perf_guest to true except for
perf-kvm, no?


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

