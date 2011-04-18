Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab1DRSad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 14:30:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49159 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab1DRSab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 14:30:31 -0400
Message-ID: <4DAC8303.2010604@kernel.org>
Date: Mon, 18 Apr 2011 11:29:23 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86, gart: Don't enforce GART aperture lower-bound
 by alignment
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com> <1303134346-5805-2-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1303134346-5805-2-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DAC830B.00CB,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2011 06:45 AM, Joerg Roedel wrote:
> This patch changes the allocation of the GART aperture to
> enforce only natural alignment instead of aligning it on
> 512MB. This big alignment was used to force the GART
> aperture to be over 512MB.

Now, memblock is used instead of bootmem, so we don't need big alignment anymore.

> This is enforced by using 512MB
> as the lower-bound address in the allocation range.
> 
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Acked-by: Yinghai Lu <yinghai@kernel.org>

Thanks

Yinghai
