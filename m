Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab2FORQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 13:16:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:48073 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab2FORQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 13:16:37 -0400
Message-ID: <1339780586.2559.90.camel@twins>
Subject: Re: [PATCH] x86, microcode: Make reload interface per system
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Date: Fri, 15 Jun 2012 19:16:26 +0200
In-Reply-To: <20120615165231.GA9169@aftab.osrc.amd.com>
References: <20120612172352.GA4802@aftab.osrc.amd.com>
	 <1339521996.31548.95.camel@twins>
	 <20120612173506.GB4802@aftab.osrc.amd.com>
	 <20120613010413.GA28174@khazad-dum.debian.net>
	 <20120613065119.GB15661@aftab.osrc.amd.com>
	 <20120613123649.GA26012@khazad-dum.debian.net>
	 <20120613161139.GA18450@aftab.osrc.amd.com>
	 <20120615123749.GC6083@aftab.osrc.amd.com> <1339764161.2559.63.camel@twins>
	 <20120615125240.GD6083@aftab.osrc.amd.com>
	 <20120615165231.GA9169@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 18:52 +0200, Borislav Petkov wrote:
> Actually, that was easier than I thought, see below. And it seems to
> workie too. 

This is on top of that other patch that makes reload_store() do the
whole system, right?
