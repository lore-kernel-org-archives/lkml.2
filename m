Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab1G3QT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 12:19:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:51602 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab1G3QTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 12:19:23 -0400
Date: Sat, 30 Jul 2011 17:19:06 +0100 (BST)
From: David Woodhouse <dwmw2@infradead.org>
X-X-Sender: dwmw2@localhost6.localdomain6
To: Arnaud Lacombe <lacombar@gmail.com>
cc: Michal Marek <mmarek@suse.cz>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [PATCH v3] x86, kconfig: Default to ARCH=x86 to avoid overriding
 CONFIG_64BIT
In-Reply-To: <CACqU3MXeUiiQPc4t9bT7KuXuAjkN+t8eFn9SYOouPg-3hDgjWQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1107301716430.21839@localhost6.localdomain6>
References: <1306707270.2029.377.camel@i7.infradead.org> <20110530072300.GA9802@elte.hu> <1306745835.2029.389.camel@i7.infradead.org> <20110530104231.GF17821@elte.hu> <20110530104656.GA19532@elte.hu> <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
 <20110530105809.GA20133@elte.hu> <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu> <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6> <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com> <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
 <1306795186.2029.459.camel@i7.infradead.org> <BANLkTik=uHr1eX44XV1pAHUfVQ-MorzOnw@mail.gmail.com> <1306856937.27477.3.camel@i7.infradead.org> <BANLkTi=VoL8ze0AcdkG_QmEH5049X2K6Zw@mail.gmail.com> <4E0495F4.7080300@suse.cz> <1311986969.20983.52.camel@i7.infradead.org>
 <CACqU3MXeUiiQPc4t9bT7KuXuAjkN+t8eFn9SYOouPg-3hDgjWQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jul 2011, Arnaud Lacombe wrote:

> this is breaking ARCH=um.

Breaking in what way? Is it just that ARCH=um is broken for SUBARCH=x86, 
and needed to be updated anyway? And still works is you manually set 
SUBARCH to one of the legacy values?

I'll try to reproduce and take a look later thuis evening.

-- 
dwmw2

