Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab2LJOgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:36:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53341 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab2LJOgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:36:16 -0500
Date: Mon, 10 Dec 2012 08:36:09 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Markku Savela <msa@moth.iki.fi>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
Message-ID: <20121210143609.GB8137@sergelap>
References: <20121204135445.GA7420@mail.hallyn.com>
 <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com>
 <20121205210528.GA9047@sergelap>
 <CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com>
 <20121205222040.GB14884@sergelap>
 <50C13F0E.5010401@schaufler-ca.com>
 <20121207144233.GA6681@mail.hallyn.com>
 <CALQRfL6c2nOSOR00YsBhgC=KWSWB-xOsDTJiLzbtmj6Zv1Mr2Q@mail.gmail.com>
 <CALCETrUwVO6YjO-VzwBO59z4L2zB+-Zd_V-ontciMEFzRHzDFQ@mail.gmail.com>
 <CALQRfL4iaHQgQ_PY44xYsyZc3fn4J+9Aw3bMfpPMSbE=4AymSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALQRfL4iaHQgQ_PY44xYsyZc3fn4J+9Aw3bMfpPMSbE=4AymSA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> > It breaks down because, currently, users with nonzero pI have no
> > direct ability to wield the capabilities.  That means that every
> > single binary with fI bits set needs to be as careful as a setuid-root
> > binary to avoid leaking privilege to the caller.  (Obviously, binaries
> > with fP set need to be careful.  IMO binaries with only fI set should
> > not need to exercise any particular care to defend themselves from
> > their callers.)
> 
> True.

Uh, I disagree.  Not true.

(I suspect Andrew meant True to the first two sentences, not the
last parenthesized one?)

-serge
