Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2LJO2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:28:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab2LJO2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:28:09 -0500
Date: Mon, 10 Dec 2012 08:27:57 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@canonical.com>,
        linux-security-module@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        Markku Savela <msa@moth.iki.fi>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
Message-ID: <20121210142757.GA8137@sergelap>
References: <CALQRfL7e160D+vzVhT-fUS-_Yp55wqnWkRFJdDTOOVjjStd9Jw@mail.gmail.com>
 <CALCETrXUSz9EN-tGMfJkw9+1kO0hfmQk4E5XPF0cg9nmpPXepg@mail.gmail.com>
 <20121204135445.GA7420@mail.hallyn.com>
 <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com>
 <20121205210528.GA9047@sergelap>
 <CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com>
 <20121205222040.GB14884@sergelap>
 <50C13F0E.5010401@schaufler-ca.com>
 <20121207144233.GA6681@mail.hallyn.com>
 <CALQRfL6UWLFpTfvan9oirtLdozJqZX4oZwDuQFVnJp8MP06C_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALQRfL6UWLFpTfvan9oirtLdozJqZX4oZwDuQFVnJp8MP06C_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> I'm still missing something with the problem definition.
> 
> So far if I follow the discussion we have determined that inheritance as
> implemented is OK except for the fact that giving user an inheritable pI
> bit which gives them default permission to use all binaries endowed with
> the corresponding file fI bit.

There is another objection which ahs been raised, namely that it leaves too
many tiny but crucial bits of security relevant information spread throughout
the filesystem.

This has also been said about using security.selinux xattrs.  The answer as
there could be a good set of tools to set and report the system wide state.
In fact, libcap-ng provides such tools, to list the file capabilities
throughout the system and capabilities in use by all running programs.

-serge
