Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2IMTYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 15:24:14 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51936 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab2IMTYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 15:24:10 -0400
Message-ID: <1347564136.2270.4.camel@falcor>
Subject: Re: [PATCH 1/2] module: add syscall to load module from fd
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Date: Thu, 13 Sep 2012 15:22:16 -0400
In-Reply-To: <878vcfu22s.fsf@rustcorp.com.au>
References: <1346955201-8926-1-git-send-email-keescook@chromium.org>
	 <50500C5C.8060006@zytor.com> <878vcfu22s.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12091319-8974-0000-0000-00000DB3C016
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00173854; UDB=6.00039376; UTC=2012-09-13
 19:24:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 17:04 +0930, Rusty Russell wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
> > On 09/06/2012 11:13 AM, Kees Cook wrote:
> >> Instead of (or in addition to) kernel module signing, being able to reason
> >> about the origin of a kernel module would be valuable in situations
> >> where an OS already trusts a specific file system, file, etc, due to
> >> things like security labels or an existing root of trust to a partition
> >> through things like dm-verity.
> >>
> >> This introduces a new syscall (currently only on x86), similar to
> >> init_module, that has only two arguments. The first argument is used as
> >> a file descriptor to the module and the second argument is a pointer to
> >> the NULL terminated string of module arguments.
> >>
> >
> > Please use the standard naming convention, which is an f- prefix (i.e. 
> > finit_module()).
> 
> Good point; I just did a replace here.

Have you pushed out the changes?  And if so, to where?

thanks,

Mimi

