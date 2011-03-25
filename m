Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1CYFr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 01:47:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42672 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab1CYFr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 01:47:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=O8fK5UFXCv75G6KUdlXsfOb2CkdimkdbebcVAsECDcIgafDA05ILB+1lUr6Cfviuzt
         uagYz7IsphJZsUHAr70jYVn52sbImrtDbGR2V2rp4FvTlfeeYpFD+75lY9oxoZRURhYz
         clb+a6WtX8UxtiCPJHV8YTuxJvXY9BUWocZSI=
Subject: Re: [PATCH RFC] x86: avoid atomic operation in
 test_and_set_bit_lock if possible
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
        Jan Beulich <JBeulich@novell.com>, Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20110324235654.GM21838@one.firstfloor.org>
References: <20110324085647.GI30812@elte.hu> <20110324145221.GC31194@aftab>
	 <4D8B83DA02000078000381DE@vpn.id2.novell.com>
	 <20110324173020.GA26761@sgi.com> <20110324200010.GB7957@elte.hu>
	 <1300999682.2714.23.camel@edumazet-laptop> <20110324205422.GB2393@elte.hu>
	 <1301000557.2714.33.camel@edumazet-laptop> <m2oc50kxg0.fsf@firstfloor.org>
	 <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com>
	 <20110324235654.GM21838@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 06:47:20 +0100
Message-ID: <1301032040.2714.569.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 25 mars 2011 à 00:56 +0100, Andi Kleen a écrit :
> > never EVER seen any good explanation of why that particular sh*t
> > argument would b true. It seems to be purely about politics, where
> > some idiotic vendor (namely HP) has convinced Intel that they really
> > need it. To the point where some engineers seem to have bought into
> > the whole thing and actually believe that fairy tale ("firmware can do
> > better" - hah! They must be feeding people some bad drugs at the
> > cafeteria)
> 
> For the record I don't think it's a good idea for the BIOS to do 
> this (and I'm not aware of any engineer who does),  
> but I think Linux should do better than just disabling PMU use when 
> this happens.
> 
> However I suspect taking over SCI would cause endless problems
> and is very likely not a good idea.

I tried many different changes in BIOS and all failed (the machine is
damn slow at boot, this takes age).

I am stuck :(

Thanks


