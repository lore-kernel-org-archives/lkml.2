Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab2JEGlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 02:41:20 -0400
Received: from ozlabs.org ([203.10.76.45]:55332 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab2JEGkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 02:40:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kasatkin@ozlabs.org, Dmitry <dmitry.kasatkin@intel.com>
Cc: "Kees Cook" <keescook@chromium.org>, "David Howells" <dhowells@redhat.com>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "Mimi Zohar" <zohar@linux.vnet.ibm.com>
Subject: Module xattr signatures
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 05 Oct 2012 11:17:11 +0930
Message-ID: <87a9w11yhs.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

        Had a talk with Mimi, and IMA still wants xattr signatures on
modules like they have for other files with EVM.  With Kees' patches now
merged into my modules-wip branch (warning, rebases frequently), this
should be pretty simple.  Dmitry?

        The question of whether this falls back to appended signatures
if there's no xattr support, or whether we fix cpio depends on whether
someone is prepared to do the latter.  As Mimi points out, AIX, bsd,
solaris all have versions of cpio that support extended attributes, as
does the bsdcpio Debian package, for example.

Thanks,
Rusty.
