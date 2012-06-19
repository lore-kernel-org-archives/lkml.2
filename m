Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab2FSISA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:18:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:34929 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2FSIR6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:17:58 -0400
Message-ID: <1340093864.21745.6.camel@twins>
Subject: Re: [PATCH] x86, microcode: Make reload interface per system
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Date: Tue, 19 Jun 2012 10:17:44 +0200
In-Reply-To: <20120619051116.GB31591@aftab.osrc.amd.com>
References: <20120613010413.GA28174@khazad-dum.debian.net>
	 <20120613065119.GB15661@aftab.osrc.amd.com>
	 <20120613123649.GA26012@khazad-dum.debian.net>
	 <20120613161139.GA18450@aftab.osrc.amd.com>
	 <20120615123749.GC6083@aftab.osrc.amd.com> <1339764161.2559.63.camel@twins>
	 <20120615125240.GD6083@aftab.osrc.amd.com>
	 <20120615165231.GA9169@aftab.osrc.amd.com>
	 <20120619024639.GB6186@khazad-dum.debian.net> <4FDFF27C.5000205@zytor.com>
	 <20120619051116.GB31591@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 07:11 +0200, Borislav Petkov wrote:
> $ rmmod microcode; modprobe microcode
> 
> but then the same guys come :-) and say they don't want to reload
> modules for security reasons. 

Nah, they built their kernel without modules, much more secure!
