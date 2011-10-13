Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab1JMOLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:11:06 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:53713 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab1JMOLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:11:03 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz9371K1432N98dKzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Kumar Gala <galak@kernel.crashing.org>, "Hans J. Koch" <hjk@hansjkoch.de>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Kai-B18973 <B18973@freescale.com>
Subject: Re: [PATCH] uio: Support 36-bit physical addresses on 32-bit systems
Thread-Topic: [PATCH] uio: Support 36-bit physical addresses on 32-bit
 systems
Thread-Index: AQHMibHu3H/ro6x8TUusGEVtiw0Y2Q==
Date: Thu, 13 Oct 2011 14:10:59 +0000
Message-ID: <CAOZdJXVLhe3aNM669sRFmDpHGCVRrP_93xdDwsY9R2VzHUZ-eQ@mail.gmail.com>
References: <1318430145-19898-1-git-send-email-galak@kernel.crashing.org>
	<20111012153229.GB21852@local>
	<AD39F4F8-E9C0-4090-9AEA-644F82DD328B@kernel.crashing.org>
	<CAMuHMdU1rHDvZEknNqKLHyBmJ26kH7SJtxsOZmOysrSzg6bz4g@mail.gmail.com>
In-Reply-To: <CAMuHMdU1rHDvZEknNqKLHyBmJ26kH7SJtxsOZmOysrSzg6bz4g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.17.22.104]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <DFE162D69A54F146879FBBEEDBC6F30C@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 11:15 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
>> Do we believe phys_addr_t is always greater than or equal to size need for logical & virtual addresses?
>
> Yes:
>
> #ifdef CONFIG_PHYS_ADDR_T_64BIT
> typedef u64 phys_addr_t;
> #else
> typedef u32 phys_addr_t;
> #endif

This isn't really an answer to the question.  This just says that
phys_addr_t can be 64-bit.  I don't see anywhere in the kernel that we
*enforce* or *require* that sizeof(phys_addr_t) >= sizeof(void *).

-- 
Timur Tabi
Linux kernel developer at Freescale
