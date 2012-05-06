Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2EFTVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 15:21:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40774 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab2EFTVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 15:21:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120506101141.GI26481@n2100.arm.linux.org.uk>
References: <1336180444-26563-1-git-send-email-ccross@android.com>
	<20120505164933.GQ897@n2100.arm.linux.org.uk>
	<20120506101141.GI26481@n2100.arm.linux.org.uk>
Date: Sun, 6 May 2012 12:21:13 -0700
X-Google-Sender-Auth: MgU1XFHHqnaH9Mp5TQaqDZ84Hp0
Message-ID: <CAMbhsRTpOhBvaucV0CWNHTMbWLW4iKMrF16kL5BoTFnudtxs9g@mail.gmail.com>
Subject: Re: [PATCH] ARM: SMP: prevent use of the console when using idmap_pgd
From: Colin Cross <ccross@android.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 6, 2012 at 3:11 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, May 05, 2012 at 05:49:33PM +0100, Russell King - ARM Linux wrote:
>> I think this is fine.  Please put it in the patch system, thanks.
>
> It looks like this bug affects v3.2 kernels as well - should it be marked
> for the attention of the stable kernel team?

I think it was introduced in v3.3, it should probably go to stable.
