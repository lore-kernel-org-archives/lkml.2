Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab1CAO21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:28:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:50155 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756471Ab1CAO2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:28:25 -0500
Date: Tue, 1 Mar 2011 15:28:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Steve French <smfrench@gmail.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/21]fs:cifs:connect.c remove one to many l's in the
 word.
In-Reply-To: <AANLkTimneD0d=qpTq2CMpfvjYuQC2kx1mf2ZnORG32KK@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1103011526560.32580@pobox.suse.cz>
References: <1298614502-4114-1-git-send-email-justinmattock@gmail.com> <AANLkTimneD0d=qpTq2CMpfvjYuQC2kx1mf2ZnORG32KK@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011, Steve French wrote:

> merged into cifs-2.6.git

Doesn't seem to be in linux-next as of today. Is cifs tree not being 
merged into linux-next?

> 
> On Fri, Feb 25, 2011 at 12:15 AM, Justin P. Mattock
> <justinmattock@gmail.com> wrote:
> > The patch below removes an extra "l" in the word.
> >
> > Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> >
> > ---
> >  fs/cifs/connect.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 8d6c17a..ea4a146 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -722,7 +722,7 @@ multi_t2_fnd:
> >                sock_release(csocket);
> >                server->ssocket = NULL;
> >        }
> > -       /* buffer usuallly freed in free_mid - need to free it here on exit */
> > +       /* buffer usually freed in free_mid - need to free it here on exit */
> >        cifs_buf_release(bigbuf);
> >        if (smallbuf) /* no sense logging a debug message if NULL */
> >                cifs_small_buf_release(smallbuf);

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
