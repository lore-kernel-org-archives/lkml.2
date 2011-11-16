Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab1KPMvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 07:51:14 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51045 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab1KPMvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 07:51:13 -0500
Date: Wed, 16 Nov 2011 12:50:52 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>, x86@kernel.org,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [v2 3/4] platform: (TS-5500) add LED support
Message-ID: <20111116125052.GC773@sirena.org.uk>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1314402027-11293-4-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20111012153415.GA26529@elte.hu>
 <20111016014203.1dfb2cb8@lenov0n>
 <20111015145646.GA9516@elte.hu>
 <20111116054156.GA20847@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111116054156.GA20847@elte.hu>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 06:41:56AM +0100, Ingo Molnar wrote:

>  32a85aa727ce: x86/platform: Add TS-5500 ADC support
>  3a338d79aa95: x86/platform: Add TS-5500 LED support
>  2437b498abac: x86/platform: Add TS-5500 GPIO support

Looking at these they all still have outstanding issues from code review
- from a quick glance they're all in the arch directory rather than the
relevant drivers directories and the GPIO driver is still replicating
functionality from the core in the driver (for detecting busy GPIOs).
