Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1HDM7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 08:59:00 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44545 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1HDM6w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 08:58:52 -0400
MIME-Version: 1.0
In-Reply-To: <1312462417-8826-1-git-send-email-miklos@szeredi.hu>
References: <1312462417-8826-1-git-send-email-miklos@szeredi.hu>
Date: Thu, 4 Aug 2011 15:58:52 +0300
X-Google-Sender-Auth: kUA_BP6Swv2AhAv2noXmSd5IVbs
Message-ID: <CAOJsxLHGw_33KzXnRdi-YbR8R2Weeg=9vb+8KucajkZgW2Y8NA@mail.gmail.com>
Subject: Re: [PATCH 0/8] overlay filesystem: request for inclusion
From: Pekka Enberg <penberg@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com, dhowells@redhat.com,
        hpj@urpla.net, sedat.dilek@googlemail.com, mszeredi@suse.cz,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

On Thu, Aug 4, 2011 at 3:53 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Al, Linus and all interested parties,
>
> Here's the latest version of overlayfs.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v11
>
> I think it's been merge-ready for some time and has gotten a fair
> amount of attention and testing from various parties.  Yet,
> apparently, it isn't getting closer to being merged.

I'm not commenting on the code but as I've mentioned privately, we're
really interested in seeing this merged for tools/kvm. We've been able
to use overlayfs to turn host filesystem into copy-on-write guest
image that's booted through 9p. So if overlayfs is merged, we'll
definitely use it.

                        Pekka
