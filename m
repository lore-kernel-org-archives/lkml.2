Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab2FSUXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 16:23:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55673 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323Ab2FSUXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 16:23:41 -0400
Message-ID: <4FE0DF9F.10401@zytor.com>
Date: Tue, 19 Jun 2012 13:22:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@amd64.org>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] x86, microcode: Make reload interface per system
References: <20120615123749.GC6083@aftab.osrc.amd.com> <1339764161.2559.63.camel@twins> <20120615125240.GD6083@aftab.osrc.amd.com> <20120615165231.GA9169@aftab.osrc.amd.com> <20120619024639.GB6186@khazad-dum.debian.net> <4FDFF27C.5000205@zytor.com> <20120619051116.GB31591@aftab.osrc.amd.com> <1340093864.21745.6.camel@twins> <20120619102250.GA787@aftab.osrc.amd.com> <1340101568.21745.37.camel@twins> <20120619182228.GA18816@khazad-dum.debian.net>
In-Reply-To: <20120619182228.GA18816@khazad-dum.debian.net>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 11:22 AM, Henrique de Moraes Holschuh wrote:
> 
> Even if we have the very early microcode facility, we *still* want the
> runtime one based on sysfs+request_firmware in order to update microcode
> without the need for a reboot.
> 

I am slightly questioning the clause "based on sysfs+request_firmware"
in the above sentence, but again, not a huge deal either way.

	-hpa
