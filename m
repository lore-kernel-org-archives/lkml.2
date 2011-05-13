Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300Ab1EMNIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:08:05 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:56870 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759242Ab1EMNID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:08:03 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zzbb2dK1433M9371O1432N98dKzz1202hzzz32i668h839h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LL4XT6-02-6RQ-02
X-M-MSG: 
Message-ID: <4DCD2C3F.9070905@amd.com>
Date: Fri, 13 May 2011 09:03:59 -0400
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Hans Rosenfeld <hans.rosenfeld@amd.com>, Chuck Ebbert <cebbert@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH] cpu, AMD: Fix another bug in the new errata checking
 code
References: <20110512195938.1728ab52@katamari> <20110513102154.GB9270@escobedo.osrc.amd.com>
In-Reply-To: <20110513102154.GB9270@escobedo.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2011 06:21 AM, Hans Rosenfeld wrote:
> On Thu, May 12, 2011 at 07:59:38PM -0400, Chuck Ebbert wrote:
> The revision guide states that family 0x10 model 6 stepping 2 has E400.
> So I would expect that OSVW length is>= 2 and that OSVW status has bit
> 1 set, or that OSVW length is<  2. This indicates that the workaround is
> necessary, without any need to check the family-model-stepping ranges.
>
> It would also be correct if the BIOS disabled C1E and cleared the
> corresponding OSVW status bit. Anything else would probably be a very
> nasty BIOS bug.
>
> Could you send me the contents of MSRs 0xc0010140, 0xc0010141 and
> 0xc0010055?

Knowing whether any C state above C1 is declared could be useful too.

-boris

