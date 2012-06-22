Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059Ab2FVRyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 13:54:16 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:38642
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932079Ab2FVRyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 13:54:15 -0400
X-Forefront-Antispam-Report: CIP:157.56.234.149;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0710HT005.namprd07.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: PS-5(zzbb2dI98dI9371I1432I4015Izz1202hzzz2dh2a8h668h839hd25he5bhf0ah)
Message-ID: <4FE4B13E.10709@caviumnetworks.com>
Date: Fri, 22 Jun 2012 10:54:06 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Yoichi Yuasa <yuasa@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Mundt <lethal@linux-sh.org>, <linux-kernel@vger.kernel.org>,
        Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] MIPS: fix bug.h MIPS build regression
References: <1339962373-3224-1-git-send-email-geert@linux-m68k.org> <CAMuHMdVfLjgrtWoPpvbLf12+=ApE6W9dNcweqD-_2Benr-D7NQ@mail.gmail.com> <20120620152759.2caceb8c.yuasa@linux-mips.org> <20120620161249.GB29196@linux-mips.org>
In-Reply-To: <20120620161249.GB29196@linux-mips.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 09:12 AM, Ralf Baechle wrote:
> On Wed, Jun 20, 2012 at 03:27:59PM +0900, Yoichi Yuasa wrote:
>
>> Commit: 3777808873b0c49c5cf27e44c948dfb02675d578 breaks all MIPS builds.
>
> Thanks, fix applied.
>

Where was it applied?

It doesn't show up in linux-next for 20120622, which is where it is needed.

David Daney


