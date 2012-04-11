Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761160Ab2DKULM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:11:12 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:41562
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261Ab2DKULL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:11:11 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzzz2dh668h839h944hd25hd2bh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2C02I-01-E4P-02
X-M-MSG: 
Date: Wed, 11 Apr 2012 22:10:54 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Kay Sievers <kay.sievers@vrfy.org>, <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: Conversion from sysdev class caused regression
Message-ID: <20120411201053.GF18114@aftab>
References: <20120411163849.GE4794@alberich.amd.com>
 <20120411200601.GC12288@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120411200601.GC12288@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 01:06:01PM -0700, Greg Kroah-Hartman wrote:
> That's not nice, but why is the driver getting loaded for a CPU that it
> doesn't control?  Startup scripts?
> 
> It's just a "warning", everything else still works properly, right?

Yes.

> Patches to fix this up are always gladly accepted :)

Yeah, we'll send you a fix probably tomorrow.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

