Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1KWT15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 14:27:57 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:55257 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754012Ab1KWT14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 14:27:56 -0500
Subject: Re: [PATCH v5 10/10] x86, efi: EFI boot stub support
From: Matt Fleming <matt@console-pimps.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <4ECC4207.3010607@gmail.com>
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
	 <1318848017-12301-11-git-send-email-matt@console-pimps.org>
	 <4E9C8AAC.7080803@gmail.com>
	 <1321383097.2657.9.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4ECC4207.3010607@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Nov 2011 19:27:48 +0000
Message-ID: <1322076468.24448.18.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 01:44 +0100, Maarten Lankhorst wrote:
> When I tested this with v3.2-rc2 it didn't boot, it hung before it
> initialized the kernel.
> Without initrd it works fine, though.

Bah, so this change actually makes booting worse? You said before that
you almost made it to userspace but this seems to hang much earlier now.
Is that correct?

... back to the drawing board.

-- 
Matt Fleming, Intel Open Source Technology Center

