Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1JAJTk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 05:19:40 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:55537 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752337Ab1JAJTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 05:19:34 -0400
Subject: Re: [PATCH v4 10/10] x86, efi: EFI boot stub support
From: Matt Fleming <matt@console-pimps.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Shea Levy <shea@shealevy.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mike Waychison <mikew@google.com>, Matthew Garrett <mjg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <4E86C64C.8020408@gmail.com>
References: <1316607036-9235-1-git-send-email-matt@console-pimps.org>
	 <1317372688-15150-1-git-send-email-matt@console-pimps.org>
	 <4E85ED25.6060208@shealevy.com>
	 <1317413508.3375.40.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4E86C64C.8020408@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 01 Oct 2011 10:19:23 +0100
Message-ID: <1317460763.3375.42.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-01 at 09:50 +0200, Maarten Lankhorst wrote:
> Cute, I think you reintroduced the same bug in v4 with load_options_size ;)
> 
> Shouldn't it be /= 2 ?

Gah! Yeah, you're right, it's just been one of those weeks. Thanks.

-- 
Matt Fleming, Intel Open Source Technology Center

