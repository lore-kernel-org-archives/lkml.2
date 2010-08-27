Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab0H0W2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 18:28:03 -0400
Received: from toccata.ens-lyon.org ([140.77.166.68]:58262 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab0H0W2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 18:28:01 -0400
Date: Sat, 28 Aug 2010 00:27:38 +0200
From: =?iso-8859-1?Q?Sh=E9rab?= <Sebastien.Hinderer@ens-lyon.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andres Salomon <dilinger@queued.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Thibault <Samuel.Thibault@ens-lyon.org>
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
Message-ID: <20100827222738.GA3053@pema>
References: <20100825094925.GA3632@pema>
 <alpine.LFD.2.00.1008261406480.2062@localhost.localdomain>
 <20100826210815.GA18131@pema>
 <4C76D9A0.2010907@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C76D9A0.2010907@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for the previous message, certainly a wrong editing command.

> What about APM?

I couldn't compile the kernel with APM support.
I'm on master, APM depends on PM_SLEEP which I couldn't find in any
Kconfig file. So I added it by hand in.config and ran make menuconfig
again. This time the APM stuff was visible, so I could activate it,
but then compiling the kernel failed.
I'm sure I'm missing something and I'm sorry about that, if someone
could help that would be very appreciated.

Thanks,
Shérab.
