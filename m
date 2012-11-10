Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab2KJXpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 18:45:38 -0500
Received: from catholic.ebb.org ([67.207.139.67]:44080 "EHLO catholic.ebb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab2KJXpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 18:45:36 -0500
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Nov 2012 18:45:36 EST
From: "Bradley M. Kuhn" <bkuhn@sfconservancy.org>
To: nab@risingtidesystems.com, Andy Grover <agrover@redhat.com>,
        Marc Fleischmann <mwf@risingtidesystems.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        legal@lists.gpl-violations.org
Subject: Re: scsi target, likely GPL violation
Organization: Software Freedom Conservancy
References: <509A915B.30105@redhat.com>
	<CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>
	<509B117A.6070708@genband.com> <509BE460.6010404@redhat.com>
	<1352405111.29589.476.camel@haakon2.linux-iscsi.org>
	<509C22B2.8010600@redhat.com>
	<1352426896.29589.512.camel@haakon2.linux-iscsi.org>
Date: Sat, 10 Nov 2012 18:32:16 -0500
In-Reply-To: <1352426896.29589.512.camel@haakon2.linux-iscsi.org> (Nicholas
	A. Bellinger's message of "Thu, 08 Nov 2012 18:08:16 -0800")
Message-ID: <87obj5uj9b.fsf@ebb.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This thread is certainly fascinating.  As someone who has enforced the
GPL for over a decade, and who coordinates a coalition of Linux
developers who do GPL enforcement, I am very concerned about any
accusation of GPL violation, and I hope that this situation can be
resolved reasonably and swiftly.

While I usually encourage private discussion about GPL violations -- at
least to start -- I've also often found it's nearly impossible to
maintain perfect secrecy about alleged GPL violations; openness and
public discussions are the standard manner of group communication in the
Free Software community.  I hope that Rising Tide Systems and its agents
are cognizant of this nature of the Free Software community.
Furthermore, now that the discussion is public anyway, I hope Rising
Tide Systems and its agents will welcome it and avoid any further
actions to squelch such discussion.

I suggest, though, that perhaps one of the mailing lists that Harlad
Welte runs for his GPL Violations Project (such as
http://lists.gpl-violations.org/mailman/listinfo/legal/ ) might be a
better forum for this thread, rather than the technical discussion
mailing lists for Linux and the subsystems in question.

Meanwhile, I don't have too much to comment on in detail on this thread
publicly at this time, but I do have a few points below:

Nicholas Bellinger wrote at 21:08 (EST) on Thursday:
> A substantial fraction of the code of which we own the sole copyright
> was certified by BlackDuck Software as early as in 2007.

Often in my work enforcing the GPL, companies have unsuccessfully
proposed a Blackduck review as a defense of copyright infringement.  I
don't think Blackduck's system does anything to determine whether or not
something is a derivative work under copyright law and/or whether a
violation of GPL has occurred.

Indeed, I know of no algorithmic way to make such determinations, and
I'm quite sure they're undecidable problems (in the computability theory
sense).  To my knowledge, Blackduck's proprietary tool is merely an
scanning tool examining source code for copyright header information and
to pattern-match against other codebases in Blackduck's private
database.  (Although, since Blackduck's software is proprietary,
trade-secret software, it's impossible to know for sure what it actually
does, but we can be sure it doesn't solve any problems that are known to
be unsolvable.)  Thus, citing a Blackduck certification is simply
off-point in refuting an accusation of any form of copyright
infringement.  Blackduck's software might be able to tell you if you *have*
plagiarized someone's source code that appears in their databases, but
they can't possibly tell you that you haven't infringed any copyrights.
I'm quite sure Blackduck doesn't give away certification on the latter
point.

> So..., Andy, please start behaving properly ...  [you aren't] be[ing]
> ... professional in ... communications about licensing compliance
> matters,

I don't think it's reasonable to chastise Andy for raising these
questions.  While I personally (and Conservancy as an organization)
don't usually raise accusations of GPL violations publicly until other
methods of private communication are attempted, I believe public
discussion is an important component of GPL compliance. Thus, Andy's
strategy of discussing it publicly early in the process -- while not my
preferred strategy -- is still a reasonable one.  His attempt to raise
these serious and legitimate concerns and questions is in no way
unprofessional, nor should it be squelched.
-- 
Bradley M. Kuhn, Executive Director, Software Freedom Conservancy
