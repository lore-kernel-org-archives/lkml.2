Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab2LRPTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:19:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34093 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119Ab2LRPTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:19:07 -0500
Date: Tue, 18 Dec 2012 16:19:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeff Layton <jlayton@redhat.com>
Cc: Steve French <smfrench@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: Do not enable debugging code by default
Message-ID: <20121218151904.GC31255@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
References: <1355737085-6671-1-git-send-email-bp@alien8.de>
 <CAH2r5mt=4ZoGR_4hP52uHsZabXpPfh1sa1X0GSg6W4=fawNFnA@mail.gmail.com>
 <20121218071317.01cbc41b@tlielax.poochiereds.net>
 <20121218144452.GB31255@liondog.tnic>
 <20121218100702.478fc1b1@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121218100702.478fc1b1@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 10:07:02AM -0500, Jeff Layton wrote:
> Yeah, not many do, but presumably they'll set it once and forget about
> it. Once someone straightens them out, they should rarely break.
>
> OTOH, the value of defaulting to "N" is pretty low here. Maybe it
> would just be best to just drop this patch and have the embedded folks
> turn this off on their own.

Yeah, sure.

I just thought you have this debugging code forked out of the driver and
it should be enabled only for when there are issues.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
