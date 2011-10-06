Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935602Ab1JFAHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 20:07:36 -0400
Received: from claw.goop.org ([74.207.240.146]:60047 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935554Ab1JFAHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 20:07:35 -0400
Message-ID: <4E8CF143.4060402@goop.org>
Date: Wed, 05 Oct 2011 17:07:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Adrian Bunk <bunk@stusta.de>, "Ted Ts'o" <tytso@mit.edu>,
        "Frank Ch. Eigler" <fche@redhat.com>, Valdis.Kletnieks@vt.edu,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
References: <201110021354.57995.rjw@sisk.pl> <4E88A537.4010008@zytor.com> <20111003093239.GB25136@localhost.pp.htv.fi> <y0mobxyjazi.fsf@fche.csb> <20111003180441.GD3072@localhost.pp.htv.fi> <34045.1317760188@turing-police.cc.vt.edu> <20111004223932.GA3460@localhost.pp.htv.fi> <20111004231730.GB17089@redhat.com> <20111005075438.GA29441@localhost.pp.htv.fi> <20111005170616.GD4297@thunk.org> <20111005192349.GA14406@localhost.pp.htv.fi> <alpine.LFD.2.02.1110060101130.18778@ionos>
In-Reply-To: <alpine.LFD.2.02.1110060101130.18778@ionos>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 04:57 PM, Thomas Gleixner wrote:
> I really do not care about your ID card, because it's a fact that
> people got keys signed by showing fake IDs.

Right, but who cares about "fake" or "real" anyway?

The point is that a given patch submitter builds up a reputation over
time.  Someone pretending to be that submitter is essentially riding on
someone else's reputation.  A web of trust and gpg signatures help
prevent this.

But having a reputation doesn't mean all your patches are good, or that
you won't suddenly turn mad or evil.  But that's not something that a
gpg signature can help with; it can only be dealt with a human
understanding of how other humans behave (and code review).

    J
