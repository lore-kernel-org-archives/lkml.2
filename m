Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab2K3NEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 08:04:15 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51380 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab2K3NEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 08:04:14 -0500
MIME-Version: 1.0
In-Reply-To: <1354273052-5203-2-git-send-email-laurent.navet@gmail.com>
References: <1354273052-5203-1-git-send-email-laurent.navet@gmail.com>
	<1354273052-5203-2-git-send-email-laurent.navet@gmail.com>
Date: Fri, 30 Nov 2012 14:04:12 +0100
Message-ID: <CAJSP0QXtZ=jMQp6YME4pCO0n90fPqbU7FQzPk4LsVvVjUQkc4Q@mail.gmail.com>
Subject: Re: [Line6linux-devel] [PATCH] staging: line6: pcm.c fix checkpatch issues
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "line6linux-devel@lists.sourceforge.net" 
	<line6linux-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 11:57 AM, Laurent Navet <laurent.navet@gmail.com> wrote:
> fix those checkpatch issues
> drivers/staging/line6/pcm.c:84:
>         WARNING: simple_strtoul is obsolete, use kstrtoul instead
>         call to obsolete simple_strtoul() replaced by kstrtoint()
>
> drivers/staging/line6/pcm.c:423:
>         ERROR: switch and case should be at the same indent
>         realigns comments
>
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> ---
>  drivers/staging/line6/pcm.c |   30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)

Changes are fine.

In the future, please split changes into individual patches.  For example:
Patch 1 - Rename 'rv' to 'ret'
Patch 2 - Replace decprecated simple_strtoul() with kstrtoint() in
pcm_set_impulse_period()
Patch 3 - Realign comment in line6_init_pcm() switch statement

Keeping patches focussed on doing just one thing makes it easier to
revert, bisect, and review them.

Reviewed-by: Stefan Hajnoczi <stefanha@gmail.com>
