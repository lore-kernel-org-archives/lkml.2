Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab2FSKWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:22:34 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:41103 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2FSKWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:22:33 -0400
Date: Tue, 19 Jun 2012 12:22:50 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] x86, microcode: Make reload interface per system
Message-ID: <20120619102250.GA787@aftab.osrc.amd.com>
References: <20120613123649.GA26012@khazad-dum.debian.net>
 <20120613161139.GA18450@aftab.osrc.amd.com>
 <20120615123749.GC6083@aftab.osrc.amd.com>
 <1339764161.2559.63.camel@twins>
 <20120615125240.GD6083@aftab.osrc.amd.com>
 <20120615165231.GA9169@aftab.osrc.amd.com>
 <20120619024639.GB6186@khazad-dum.debian.net>
 <4FDFF27C.5000205@zytor.com>
 <20120619051116.GB31591@aftab.osrc.amd.com>
 <1340093864.21745.6.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340093864.21745.6.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 10:17:44AM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-19 at 07:11 +0200, Borislav Petkov wrote:
> > $ rmmod microcode; modprobe microcode
> > 
> > but then the same guys come :-) and say they don't want to reload
> > modules for security reasons. 
> 
> Nah, they built their kernel without modules, much more secure!

Not secure enough - they don't get microcode then (ucode loader uses
request_firmware()) and has to be module for the initial load, at least.

But I haven't tested what happens when it is built in and I use the
reload interface, hehe something to play with today.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
