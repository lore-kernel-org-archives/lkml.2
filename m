Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0IAGiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 02:38:55 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:13152 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752209Ab0IAGiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 02:38:52 -0400
Message-ID: <4C7DF4EF.30109@snapgear.com>
Date: Wed, 1 Sep 2010 16:38:39 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/22] Fix M68K irqflags
References: <AANLkTikJ5pio3WYmZFAyWpD32hssZoDxX7XSTXN_qV09@mail.gmail.com> <20100827015905.27277.39167.stgit@warthog.procyon.org.uk> <20100827020038.27277.27239.stgit@warthog.procyon.org.uk> <4C7B59E1.6010904@snapgear.com> <26799.1283201411@redhat.com> <11403.1283270415@redhat.com>
In-Reply-To: <11403.1283270415@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Sep 2010 06:38:49.0396 (UTC) FILETIME=[55D74F40:01CB49A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/10 02:00, David Howells wrote:
> Geert Uytterhoeven<geert@linux-m68k.org>  wrote:
>
>> Indeed, m68k doesn't use generic hardirqs yet, m68knommu does.
>
> That's orthogonal to this patch series, however.  I'm dealing with IRQ flags
> management, not hardirq support.
>
> Out of interest, will the m68knommu arch be integrated into the m68k arch at
> some point?  It's certainly possible to have an arch that is bimodal in this
> aspect (FRV has CONFIG_MMU as a config option).

At some point it will happen. Steven King sent a script to
largely automate for a first pass about a year ago.

Regards
Greg



