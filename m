Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab0JRR7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 13:59:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54425 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab0JRR7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 13:59:32 -0400
Date: Mon, 18 Oct 2010 13:59:16 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-bluetooth@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        steven miao <realmz6@gmail.com>
Subject: Re: [PATCH] bluetooth: fix unaligned access to l2cap conf data
Message-ID: <20101018155916.GB2468@vigoh>
References: <1287268187-9628-1-git-send-email-vapier@gentoo.org>
 <1287402706.3316.126.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287402706.3316.126.camel@aeonflux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

* Marcel Holtmann <marcel@holtmann.org> [2010-10-18 13:51:46 +0200]:

> Hi Mike,
> 
> > In function l2cap_get_conf_opt() and l2cap_add_conf_opt() the address of
> > opt->val sometimes is not at the edge of 2-bytes/4-bytes, so 2-bytes/4 bytes
> > access will cause data misalignment exeception.  Use get_unaligned_le16/32
> > and put_unaligned_le16/32 function to avoid data misalignment execption.
> > 
> > Signed-off-by: steven miao <realmz6@gmail.com>
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > ---
> > was posted a month ago with no feedback ...
> 
> must have slipped through. However I don't remember it being on
> linux-bluetooth at all. Maybe it was on the other mailing lists :(

Actually I remember it, but it got lost by some way. :(

> 
> Acked-by: Marcel Holtmann <marcel@holtmann.org>

Applied, thanks.

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
