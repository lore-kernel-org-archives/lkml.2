Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1KOMzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 07:55:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56534 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab1KOMzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 07:55:51 -0500
Date: Tue, 15 Nov 2011 16:53:33 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg KH <greg@kroah.com>, Theodore Tso <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC 1/3] procfs: parse mount options
Message-ID: <20111115125332.GA8486@albatros>
References: <20111115112151.GA3002@albatros>
 <CAM_iQpUAqDmP571R3NkYOmPC7yAEMaHTFmmQCm5hLUXV5Fh8xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM_iQpUAqDmP571R3NkYOmPC7yAEMaHTFmmQCm5hLUXV5Fh8xQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Américo,

On Tue, Nov 15, 2011 at 19:48 +0800, Américo Wang wrote:
> On Tue, Nov 15, 2011 at 7:21 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> > +
> > +static int proc_parse_options(char *options, struct pid_namespace *pid)
> > +{
> > +       char *p;
> > +       substring_t args[MAX_OPT_ARGS];
> > +       int option;
> 
> 
> 'option' is unused?

Right.

> > +               switch (token) {
> > +               default:
> 
> 
> This switch block reads odd...

It will be used in 2/3 patch.

> > +                       pr_err("proc: unrecognized mount option \"%s\" "
> > +                              "or missing value", p);
> 
> "\n" is needed.

Correct.  Thank you!

> > +                       return 0;
> > +               }
> > +       }
> > +
> > +       return 1;
> > +}

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
