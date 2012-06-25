Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab2FYWOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:14:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab2FYWOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:14:11 -0400
Date: Mon, 25 Jun 2012 15:14:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Doug Ledford <dledford@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Joe Korty <joe.korty@ccur.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5] fs: make dumpable=2 require fully qualified path
Message-Id: <20120625151409.5e13702b.akpm@linux-foundation.org>
In-Reply-To: <20120625180327.GA31931@www.outflux.net>
References: <20120625180327.GA31931@www.outflux.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012 11:03:27 -0700
Kees Cook <keescook@chromium.org> wrote:

> Instead of introducing a suid_dumpable=3 mode and breaking all users
> of mode 2, this only disables the unsafe portion of mode 2 (writing to
> disk via relative path).

It would be nicer to generate the warning at configuration time rather than
at core-dumping time.  I have a feeling that's Hard To Do, but why?
