Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab2LROo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 09:44:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40312 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066Ab2LROoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 09:44:55 -0500
Date: Tue, 18 Dec 2012 15:44:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeff Layton <jlayton@redhat.com>
Cc: Steve French <smfrench@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: Do not enable debugging code by default
Message-ID: <20121218144452.GB31255@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
References: <1355737085-6671-1-git-send-email-bp@alien8.de>
 <CAH2r5mt=4ZoGR_4hP52uHsZabXpPfh1sa1X0GSg6W4=fawNFnA@mail.gmail.com>
 <20121218071317.01cbc41b@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121218071317.01cbc41b@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 07:13:17AM -0500, Jeff Layton wrote:
> I agree that we often need cifsFYI debug info in order to troubleshoot
> problems. The question here though is whether compiling those in ought
> to be the default.
>
> In generic distro kernels, I think we do want that turned on even in
> non-debug kernels. On an embedded arch, it's less compelling.
>
> Might it make sense to couple this change with a change to the
> CONFIG_CIFS_DEBUG help text? Something like:
>
> "This option defaults to 'N', but enabling this is strongly encouraged
> unless memory is severely constrained."

... or we make it default n if EMBEDDED, otherwise default y + changing
the help text?

> Then we can just try to make sure non-embedded distros enable it.

Yeah, I don't think distros look at the help text... or?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
