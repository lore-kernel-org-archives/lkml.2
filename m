Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1AYTEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 14:04:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43556 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1AYTEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 14:04:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hVj/5DLJlkox6pXPqHhwmK/VyvBBBp1BYRn/dgm8+TxSMjVf9l6yOeyYWyWBUWgNR8
         nZoXxPhLhr5xFOn7nKdkhLrTkSAwGvovjDM4ltbosTPgTSqgRa93Yd8azDe4CCBmM7Ra
         vy5phXoRDRNAb4LR6X+mBUzPRG5Gi1mWodi9A=
Message-ID: <4D3F1EAF.1080609@garzik.org>
Date: Tue, 25 Jan 2011 14:04:15 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: "Ahmed S. Darwish" <darwish.07@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86-ML <x86@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk upon
 panic
References: <20110125134748.GA10051@laptop> <20110125140948.GA26762@elte.hu> <20110125153649.GA11386@laptop> <AANLkTikHe8Bq1f-nv8hiAeY7rs7t5MWTvEUSYT81py4S@mail.gmail.com>
In-Reply-To: <AANLkTikHe8Bq1f-nv8hiAeY7rs7t5MWTvEUSYT81py4S@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2011 12:32 PM, Tony Luck wrote:
> One more "is this bit of the BIOS code safe" concern that I have is that
> you'll be using the "write" path of the INT 0x13 code ... which isn't the
> path that is tested by booting ... it *ought* to be OK - but untested paths
> in BIOS seem to be broken paths all too often.


Not really...  as others have noted, we reprogram the controller in a 
different mode, once the kernel starts.

	Jeff


