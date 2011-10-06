Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab1JFHbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 03:31:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:35513 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab1JFHbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 03:31:10 -0400
Date: Thu, 6 Oct 2011 09:30:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Friesen <chris.friesen@genband.com>
cc: Adrian Bunk <bunk@stusta.de>, "Ted Ts'o" <tytso@mit.edu>,
        "Frank Ch. Eigler" <fche@redhat.com>, Valdis.Kletnieks@vt.edu,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
In-Reply-To: <4E8CF3C9.3080908@genband.com>
Message-ID: <alpine.LFD.2.02.1110060913360.18778@ionos>
References: <201110021354.57995.rjw@sisk.pl> <4E88A537.4010008@zytor.com> <20111003093239.GB25136@localhost.pp.htv.fi> <y0mobxyjazi.fsf@fche.csb> <20111003180441.GD3072@localhost.pp.htv.fi> <34045.1317760188@turing-police.cc.vt.edu> <20111004223932.GA3460@localhost.pp.htv.fi>
 <20111004231730.GB17089@redhat.com> <20111005075438.GA29441@localhost.pp.htv.fi> <20111005170616.GD4297@thunk.org> <20111005192349.GA14406@localhost.pp.htv.fi> <alpine.LFD.2.02.1110060101130.18778@ionos> <4E8CF3C9.3080908@genband.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011, Chris Friesen wrote:

> On 10/05/2011 05:57 PM, Thomas Gleixner wrote:
> > On Wed, 5 Oct 2011, Adrian Bunk wrote:
> 
> > > Or if I have to bother Linus to meet me and sign my key the next
> > > time he is here in Helsinki.
> > 
> > And how would that change the fact that your personal trust value in
> > this community is exactly ZERO?
> > 
> > As your idea of trust seems to be based on an ID card you better find
> > some other place with people who are stupid enough to believe that
> > technical measures can replace deep personal trust.
> 
> Aren't you sort of conflating personal trust with a web-of-trust?

No, I'm fighting the idiocy that people seem to believe that a web of
signed keys has any value other than technically establishing the
identity of a person.

> A web-of-trust exists simply to associate a person with a key.  It *is* a
> technical measure.  If Linus is willing to assert that Adrian's key matches up
> with Adrian-as-individual, and you trust Linus, then you should accept
> Adrian's key as valid regardless of whether or not you personally trust him.

If Linus signs his key, then all it means is that I can be sure to a
certain degree that the person who is using the key is Adrian. But
it's neither a free ticket for a k.org account nor does it have any
other meaning.

Thanks,

	tglx
