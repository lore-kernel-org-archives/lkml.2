Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab1GaIN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 04:13:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:53198 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab1GaIN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 04:13:26 -0400
Subject: Re: [PATCH v3] x86, kconfig: Default to ARCH=x86 to avoid
 overriding CONFIG_64BIT
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        hpa@zytor.com
Date: Sun, 31 Jul 2011 09:13:00 +0100
In-Reply-To: <CACqU3MUMj4PzOzyHUXwQKu5LqNZzY+W9amPPiw555Ae9QKqpng@mail.gmail.com>
References: <1306707270.2029.377.camel@i7.infradead.org>
	 <20110530072300.GA9802@elte.hu>
	 <1306745835.2029.389.camel@i7.infradead.org>
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
	 <CACqU3MUMj4PzOzyHUXwQKu5LqNZzY+W9amPPiw555Ae9QKqpng@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312099981.22074.73.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-31 at 01:18 -0400, Arnaud Lacombe wrote:
> If I'm reading this correctly, does this mean that someone doing an
> 'allyesconfig' on an i386 machine will get a configuration for a
> 64bits kernel[0] ? With your logic, you would require the user to
> manually specify CONFIG_64BIT=n, which should be automatic on such a
> system... 

Yes, that is entirely correct, and intentional. If the user asks for
'all yes', then the user gets 'all yes'.

We do not attempt some kind of half-baked Aunt Tillie mode where we
guess certain settings from the build host.

It's not as if people often use 'allyesconfig' to build kernels they're
actually going to *run*.

-- 
dwmw2

