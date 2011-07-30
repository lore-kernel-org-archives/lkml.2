Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab1G3Wet (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 18:34:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:53848 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab1G3Wea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 18:34:30 -0400
Subject: Re: [PATCH v3] x86, kconfig: Default to ARCH=x86 to avoid
 overriding CONFIG_64BIT
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        "Ted Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Date: Sat, 30 Jul 2011 23:34:17 +0100
In-Reply-To: <CACqU3MUfpSeHBOPjkAcpdGSugoC3w4hyCs_igUxppohPj+o=2A@mail.gmail.com>
References: <1306707270.2029.377.camel@i7.infradead.org>
	 <20110530104231.GF17821@elte.hu> <20110530104656.GA19532@elte.hu>
	 <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
	 <20110530105809.GA20133@elte.hu>
	 <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
	 <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
	 <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
	 <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
	 <1306795186.2029.459.camel@i7.infradead.org>
	 <BANLkTik=uHr1eX44XV1pAHUfVQ-MorzOnw@mail.gmail.com>
	 <1306856937.27477.3.camel@i7.infradead.org>
	 <BANLkTi=VoL8ze0AcdkG_QmEH5049X2K6Zw@mail.gmail.com>
	 <4E0495F4.7080300@suse.cz> <1311986969.20983.52.camel@i7.infradead.org>
	 <CACqU3MXeUiiQPc4t9bT7KuXuAjkN+t8eFn9SYOouPg-3hDgjWQ@mail.gmail.com>
	 <alpine.LFD.2.02.1107301716430.21839@localhost6.localdomain6>
	 <CACqU3MVY89L3B3=eFrmsgD2wzXtbQHssPm4D_-VZGEWNYBR4-Q@mail.gmail.com>
	 <4E34548F.9040909@zytor.com> <4E347FC4.60600@zytor.com>
	 <1312064244.22074.21.camel@i7.infradead.org>
	 <CACqU3MUfpSeHBOPjkAcpdGSugoC3w4hyCs_igUxppohPj+o=2A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312065261.22074.29.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-30 at 18:24 -0400, Arnaud Lacombe wrote:
> How do you plan to handle x32, if it ever makes it to mainline ? 

I was pondering that. Surely it would involve porting the kernel itself
to x32? And there's never going to be any motivation for that *other*
than UML, so I can't really see it happening.

What does 'uname -m' give under x32, anyway?


-- 
dwmw2

