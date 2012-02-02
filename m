Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab2BBXq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:46:28 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50203 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab2BBXq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:46:26 -0500
MIME-Version: 1.0
In-Reply-To: <20120202212400.GR23916@ZenIV.linux.org.uk>
References: <20120130222717.GA6393@kroah.com> <m18vkoirv9.fsf@fess.ebiederm.org>
 <4F27C6EB.2070305@suse.cz> <m14nvc82jo.fsf@fess.ebiederm.org>
 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org> <m1ehueyz20.fsf_-_@fess.ebiederm.org>
 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
 <20120202012258.GQ23916@ZenIV.linux.org.uk> <20120202212400.GR23916@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 2 Feb 2012 15:46:06 -0800
X-Google-Sender-Auth: eZE_-VGoWaEz244F1M032Di1Ozo
Message-ID: <CA+55aFzHSv2eHKenVhxnSFMJMXtJCnxD2xu6QjMiMLEGLCZ2uQ@mail.gmail.com>
Subject: Re: [RFC] killing boilerplate checks in ->link/->mkdir/->rename
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 1:24 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Comments?  Boilerplate removal follows (22 files changed, 45 insertions(+),
> 120 deletions(-)), but it's *not* for immediate merge; it's really completely
> untested.

Looks ok to me. Historically, the more things we can check at the VFS
layer, the better.

                  Linus
