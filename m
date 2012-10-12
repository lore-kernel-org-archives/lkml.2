Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab2JLNND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 09:13:03 -0400
Received: from void.printf.net ([89.145.121.20]:52383 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab2JLNNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 09:13:01 -0400
From: Chris Ball <cjb@laptop.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for mmc
References: <30707.1349789429@warthog.procyon.org.uk>
Date: Fri, 12 Oct 2012 09:12:55 -0400
In-Reply-To: <30707.1349789429@warthog.procyon.org.uk> (David Howells's
	message of "Tue, 09 Oct 2012 14:30:29 +0100")
Message-ID: <87626f3kbs.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, Oct 09 2012, David Howells wrote:
> Can you merge the following branch into the mmc tree please.
>
> This is to complete part of the Userspace API (UAPI) disintegration for which
> the preparatory patches were pulled recently.  After these patches, userspace
> headers will be segregated into:
>
> 	include/uapi/linux/.../foo.h
>
> for the userspace interface stuff, and:
>
> 	include/linux/.../foo.h
>
> for the strictly kernel internal stuff.
>
> ---
> The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:
>
>   Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)
>
> are available in the git repository at:
>
>
>   git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-mmc-20121009
>
> for you to fetch changes up to ad1cfdcef1378adc7215a74772f7d06c4cc6ef50:
>
>   UAPI: (Scripted) Disintegrate include/linux/mmc (2012-10-09 09:48:45 +0100)

Thanks, I've sent this to Linus now.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
