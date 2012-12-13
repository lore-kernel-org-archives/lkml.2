Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2LMGSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 01:18:05 -0500
Received: from www84.your-server.de ([213.133.104.84]:55432 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2LMGSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 01:18:04 -0500
Message-ID: <1355379433.24701.1.camel@wall-e>
Subject: Re: [PATCH] Add VDSO time function support for x86 32-bit kernel
From: Stefani Seibold <stefani@seibold.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net
Date: Thu, 13 Dec 2012 07:17:13 +0100
In-Reply-To: <1d3061cb-76d0-4e42-9b75-a975b05384ec@email.android.com>
References: <1355343572-23074-1-git-send-email-stefani@seibold.net>
	 <50C9148C.4040308@zytor.com> <1355378005.24283.11.camel@wall-e>
	 <1d3061cb-76d0-4e42-9b75-a975b05384ec@email.android.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 12.12.2012, 22:14 -0800 schrieb H. Peter Anvin:
> This is too late for 3.8 anyway, so there is time to make it work correctly before tge 3.9 merge window anyway.  After this merge window is over I may pull tjis into a testing branch, but compat support is a precondition.
> 
> The vdso is only optional if you build in backwards compatibility anyway, and software has a right to expect a specific numeric kernel version to export a single ABI.
> 

Any idea or clean solution how i can map the 64 bit vgtod into the 32
bit address space? Thats the only problem i see.

- Stefani


