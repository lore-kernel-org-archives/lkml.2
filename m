Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2JEOmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:42:43 -0400
Received: from mga06.intel.com ([134.134.136.21]:15960 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753676Ab2JEOmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:42:42 -0400
MIME-Version: 1.0
In-Reply-To: <87a9w11yhs.fsf@rustcorp.com.au>
References: <87a9w11yhs.fsf@rustcorp.com.au>
Date: Fri, 5 Oct 2012 17:42:40 +0300
Message-ID: <CALLzPKYTaOX0SNkT_z9snyEMSQ4paKLf3H-C=O0vM-Gc8O99UA@mail.gmail.com>
Subject: Re: Module xattr signatures
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kasatkin@ozlabs.org, Kees Cook <keescook@chromium.org>,
        David Howells <dhowells@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Oct 5, 2012 at 4:47 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> Hi all,
>
>         Had a talk with Mimi, and IMA still wants xattr signatures on
> modules like they have for other files with EVM.  With Kees' patches now
> merged into my modules-wip branch (warning, rebases frequently), this
> should be pretty simple.  Dmitry?
>

Yes, there is no difference for IMA/EVM what type of file has a
signature to verify.
It just reads the signature from the xattr. With the module hook it
will just do the same
for modules as well. It is independent of appended signature verification.
The format of signatures is different at the moment.

>         The question of whether this falls back to appended signatures
> if there's no xattr support, or whether we fix cpio depends on whether
> someone is prepared to do the latter.  As Mimi points out, AIX, bsd,
> solaris all have versions of cpio that support extended attributes, as
> does the bsdcpio Debian package, for example.
>

As I already said in one of my early mails, I am not sure at all if
IMA really needs to verify a signature,
if primary mechanism is to use appended signature.

- Dmitry

> Thanks,
> Rusty.
