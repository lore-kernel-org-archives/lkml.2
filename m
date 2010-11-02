Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab0KBRvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 13:51:43 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:46515
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510Ab0KBRvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 13:51:36 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz1432N98dNzz1202hzz8275bh8275ch15d4Rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3extmailp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LB9QXG-02-BGR-02
X-M-MSG: 
Date: Tue, 2 Nov 2010 18:51:27 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Jesper Juhl <jj@chaosbits.net>
CC: Borislav Petkov <bp@alien8.de>, <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        <amd64-microcode@amd64.org>
Subject: Re: [PATCH v2] AMD Microcode: Prefer vzalloc() over calls to
 vmalloc()+memset().
Message-ID: <20101102175127.GB2961@kryptos.osrc.amd.com>
References: <alpine.LNX.2.00.1010302118160.1572@swampdragon.chaosbits.net>
 <20101031100833.GA18633@liondog.tnic>
 <alpine.LNX.2.00.1011012020500.12889@swampdragon.chaosbits.net>
 <20101101212747.GA23907@liondog.tnic>
 <alpine.LNX.2.00.1011012239390.12889@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011012239390.12889@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 10:44:34PM +0100, Jesper Juhl wrote:
> We don't have to do memset() ourselves after vmalloc() when we have 
> vzalloc(), so change that in 
> arch/x86/kernel/microcode_amd.c::get_next_ucode().
> Thanks to Borislav Petkov for improvement suggestions.
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

