Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab1GMV7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:59:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41549 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab1GMV7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:59:52 -0400
Message-ID: <4E1E106E.4060408@zytor.com>
Date: Wed, 13 Jul 2011 14:38:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86 intel power: Initialize MSR_IA32_ENERGY_PERF_BIAS
References: <alpine.LFD.2.02.1103301819250.31342@x980> <20110414090854.GB9248@elte.hu> <alpine.LFD.2.02.1104150202310.29365@x980> <20110415101712.GB28007@elte.hu> <alpine.LFD.2.02.1107131640280.9546@x980> <CA+55aFxBkgwBbnqwO7DuizsWiVcULYtPzqr-mYrT6aHmXV0zZw@mail.gmail.com>
In-Reply-To: <CA+55aFxBkgwBbnqwO7DuizsWiVcULYtPzqr-mYrT6aHmXV0zZw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2011 01:49 PM, Linus Torvalds wrote:
> Ack. Let's just do this. Ingo?
> 
>             Linus

Ingo is travelling this week, but this seems to have converged.

	-hpa
