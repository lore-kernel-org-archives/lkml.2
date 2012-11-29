Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab2K2UOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:14:09 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:58151 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab2K2UOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:14:06 -0500
MIME-Version: 1.0
In-Reply-To: <1354219418-6882-1-git-send-email-laurent.navet@gmail.com>
References: <1354219418-6882-1-git-send-email-laurent.navet@gmail.com>
Date: Thu, 29 Nov 2012 21:14:05 +0100
Message-ID: <CAJSP0QWE2X3GYA+wh8_iZwHpjeUwe3FrM98PZQ_NvWe+_sGMXw@mail.gmail.com>
Subject: Re: [Line6linux-devel] [PATCH] staging: line6: use kstrtoint()
 instead of simple_strtoul()
From: Stefan Hajnoczi <stefanha@gmail.com>
To: "Laurent Navet [Mali]" <laurent.navet@gmail.com>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "line6linux-devel@lists.sourceforge.net" 
	<line6linux-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 9:03 PM, Laurent Navet [Mali]
<laurent.navet@gmail.com> wrote:
> From: "Laurent Navet [Mali]" <laurent.navet@gmail.com>
>
> staging: line6: pcm.c
>         call to obsolete simple_strtoul() function is replaced
>         by kstrtoint() in pcm_set_impulse_period().
>         Also check the return code.
>
> Signed-off-by: Laurent Navet [Mali] <laurent.navet@gmail.com>
> ---
>  drivers/staging/line6/pcm.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@gmail.com>
