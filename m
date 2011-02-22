Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1BVO2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:28:30 -0500
Received: from server103.greatnet.de ([83.133.97.6]:39779 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab1BVO23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:28:29 -0500
Message-ID: <4D63C809.1020507@nachtwindheim.de>
Date: Tue, 22 Feb 2011 15:28:25 +0100
From: Henrik Kretzschmar <henne@nachtwindheim.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86: move ioapic_irq_destination_types to apicdef.h
References: <1298278764-3320-1-git-send-email-henne@nachtwindheim.de> <20110222090826.GA17762@elte.hu>
In-Reply-To: <20110222090826.GA17762@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.02.2011 10:08, schrieb Ingo Molnar:
> 
> FYI, your series broke the build with the attached config:
> 
> /home/mingo/linux/linux2/arch/x86/include/asm/io_apic.h:199:47: error: parameter name omitted
> ...

Damn,

I sent you an old version and didn't noticed it.
Sorry for that, I'll resend the right patches now.

Greets,
Henrik Kretzschmar
