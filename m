Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab2LMHSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 02:18:18 -0500
Received: from www84.your-server.de ([213.133.104.84]:58850 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2LMHSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 02:18:17 -0500
Message-ID: <1355383038.18653.2.camel@wall-e>
Subject: Re: [PATCH] Add VDSO time function support for x86 32-bit kernel
From: Stefani Seibold <stefani@seibold.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net
Date: Thu, 13 Dec 2012 08:17:18 +0100
In-Reply-To: <f984cb31-baa5-4176-8e85-37266e2cfb8d@email.android.com>
References: <1355343572-23074-1-git-send-email-stefani@seibold.net>
	 <50C9148C.4040308@zytor.com> <1355378005.24283.11.camel@wall-e>
	 <1d3061cb-76d0-4e42-9b75-a975b05384ec@email.android.com>
	 <1355379433.24701.1.camel@wall-e>
	 <f984cb31-baa5-4176-8e85-37266e2cfb8d@email.android.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 12.12.2012, 22:47 -0800 schrieb H. Peter Anvin:
> Should be a simple matter of sharing pages.  Look perhaps at the x32 vdso for a hint.
> 


> >
> >Any idea or clean solution how i can map the 64 bit vgtod into the 32
> >bit address space? Thats the only problem i see.
> >

No, i see no special handling for x32 vdso to do this. I am not sure if
x32 vdso can access the 64 bit address space of vsyscall_gtod_data. I
can't test this due the lack of a x32 abi system.


