Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450Ab1LPS3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:29:38 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53336 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab1LPS3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:29:31 -0500
MIME-Version: 1.0
In-Reply-To: <4EEB85F1.7050903@zytor.com>
References: <1319145326-13902-1-git-send-email-jacob.shin@amd.com>
	<4EA09EA2.3030203@zytor.com>
	<1319149574.13035.6.camel@jshin-Toonie>
	<4EE9266A.90200@zytor.com>
	<20111214231425.GA18068@jshin-Toonie>
	<20111216162004.GC18068@jshin-Toonie>
	<4EEB8320.4010809@oracle.com>
	<4EEB85F1.7050903@zytor.com>
Date: Fri, 16 Dec 2011 10:29:31 -0800
X-Google-Sender-Auth: jbBpKewe_0iqRxyWKcpjUlIHe4E
Message-ID: <CAE9FiQXTeJ2XZy-Pjwvdb4Fp5wb_XLq88tC-2M_3RbjSLk5d4A@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86: Exclude E820_RESERVED regions and memory holes
 above 4 GB from direct mapping.
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 9:54 AM, H. Peter Anvin <hpa@zytor.com> wrote:

>
> For 2 - why can't we simply make the invariant that E820_RAM is mapped and
> nothing else, with the sole exceptions being the 1 MiB (fixed MTRR)?

Yes, we could do that. but need to track mapped area in simple way.
like later memory hotadd or remove to update those tracking.

Thanks

Yinghai
