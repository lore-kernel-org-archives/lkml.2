Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2FSK0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:26:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48732 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2FSK0W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:26:22 -0400
Message-ID: <1340101568.21745.37.camel@twins>
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
Date: Tue, 19 Jun 2012 12:26:08 +0200
In-Reply-To: <20120619102250.GA787@aftab.osrc.amd.com>
References: <20120613123649.GA26012@khazad-dum.debian.net>
	 <20120613161139.GA18450@aftab.osrc.amd.com>
	 <20120615123749.GC6083@aftab.osrc.amd.com> <1339764161.2559.63.camel@twins>
	 <20120615125240.GD6083@aftab.osrc.amd.com>
	 <20120615165231.GA9169@aftab.osrc.amd.com>
	 <20120619024639.GB6186@khazad-dum.debian.net> <4FDFF27C.5000205@zytor.com>
	 <20120619051116.GB31591@aftab.osrc.amd.com>
	 <1340093864.21745.6.camel@twins> <20120619102250.GA787@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 12:22 +0200, Borislav Petkov wrote:
> 
> But I haven't tested what happens when it is built in and I use the
> reload interface, hehe something to play with today. 

I couldn't easily find where to place the damn ucode image anyway, so I
built in the old-style /dev interface and used the microcode.ctl package
to load it.

Fwiw, that works just fine when its built-in.


