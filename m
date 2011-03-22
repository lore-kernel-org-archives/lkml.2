Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1CVS2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:28:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500Ab1CVS2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:28:35 -0400
MIME-Version: 1.0
In-Reply-To: <4D88E8EF.8000001@openwrt.org>
References: <20110322152602.053930811@szeredi.hu> <AANLkTinxD2rZnso3zfX0=-HQ9m7=zAjEtUepFO=uMe2Q@mail.gmail.com>
 <4D88E8EF.8000001@openwrt.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Mar 2011 11:27:45 -0700
Message-ID: <AANLkTikouwE+3ysKrnubHLG=egW9=GtYZMWQwTCSDoEr@mail.gmail.com>
Subject: Re: [PATCH 0/6 v7] overlay filesystem - request for inclusion
To: Felix Fietkau <nbd@openwrt.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 11:22 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>
> We're using it in OpenWrt (an Embedded Linux distribution) for devices
> with tiny amounts of flash for the entire system (e.g. 4 MB).
> We're using it to provide a writable on-flash root filesystem with
> squashfs for the read-only part and jffs2 for the writable overlay. This
> saves some precious flash space compared to using only jffs2, and it
> makes it easy for users to reset their device to defaults without having
> to reflash.
> With a backport of v6 of this series + my fixes that went into v7 this
> is working quite well on 2.6.37 and 2.6.38 - I'm using it on a few
> wireless access points at home.

Ok - sounds like an eminently sane and reasonable usage scenario.

Al?

                        Linus
