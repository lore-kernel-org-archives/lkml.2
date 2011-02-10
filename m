Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab1BJKoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 05:44:17 -0500
Received: from server103.greatnet.de ([83.133.97.6]:48960 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab1BJKoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 05:44:16 -0500
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Feb 2011 05:44:16 EST
Message-ID: <4D53BF67.50601@nachtwindheim.de>
Date: Thu, 10 Feb 2011 11:35:19 +0100
From: Henrik Kretzschmar <henne@nachtwindheim.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhead.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: fused  X86_UP_APIC and  X86_UP_IOAPIC ?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

In commit 7cd92366a593246650cc7d6198e2c7d3af8c1d8a (x86/Voyager: remove APIC/IO-APIC Kbuild quirk / just before 2.6.29-rc4)
Ingo replaced the X86_UP_IOAPIC with X86_UP_APIC.

Was this intended ord by accident?


Greets,
Henrik Kretzschmar





