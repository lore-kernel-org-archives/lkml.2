Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1G1OgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 10:36:09 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60013 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1G1OgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 10:36:08 -0400
Date: Thu, 28 Jul 2011 16:35:52 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110728143552.GC26379@aftab>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <CA+55aFwL9Fwd9ouX3UMOayoBsZyZzTdDSySa6nZJxbpyLifbaQ@mail.gmail.com>
 <20110724172222.GB12621@aftab>
 <CA+55aFze=w7tjmyGa2w=D8b6roDuL5O0gmDKkSzLKBLLYZ_a+A@mail.gmail.com>
 <20110727171015.GD19477@aftab>
 <4E3047D4.2000608@zytor.com>
 <20110728134416.GA26379@aftab>
 <4E316C06.2020609@zytor.com>
 <20110728141348.GB26379@aftab>
 <4E316FC5.7090201@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E316FC5.7090201@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 10:18:45AM -0400, H. Peter Anvin wrote:
> On 07/28/2011 07:13 AM, Borislav Petkov wrote:
> > 
> > You want them to be _GENMASK{,_UL,_ULL}? Why? Because they're "calling"
> > macros with a single underscore? Actually, I've always wondered on what
> > our exact rules on underscores are. I can deduce the nesting level of
> > macros based on number of underscores but what else?
> > 
> 
> Internal symbols used in userspace-visible headers must be from the
> namespace:
> 
> 	^_[A-Z_].*

Ah, thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
