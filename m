Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab1EPU4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:56:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48554 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563Ab1EPU4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:56:32 -0400
Message-ID: <4DD18F72.9010307@zytor.com>
Date: Mon, 16 May 2011 13:56:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4] x86: allow ZONE_DMA to be configurable
References: <alpine.DEB.2.00.1104141134260.386@chino.kir.corp.google.com> <4DA82F33.7080403@ladisch.de> <4DA8A5CE.2010004@zytor.com> <alpine.DEB.2.00.1104201929170.15661@chino.kir.corp.google.com> <4DAFAD9F.4020809@zytor.com> <alpine.DEB.2.00.1104271637310.25369@chino.kir.corp.google.com> <alpine.DEB.2.00.1105161353560.4353@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1105161353560.4353@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2011 01:54 PM, David Rientjes wrote:
> ZONE_DMA is unnecessary for a large number of machines that do not
> require addressing in the lower 16MB of memory because they do not use
> devices with 16-bit address registers (plus one page byte register).

You keep repeating this error, although this time you at least fixed the
Kconfig file.  I'll fix up the checkin message and apply.

	-hpa
