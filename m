Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042Ab0JRLvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 07:51:51 -0400
Received: from senator.holtmann.net ([87.106.208.187]:49378 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab0JRLvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 07:51:49 -0400
Subject: Re: [PATCH] bluetooth: fix unaligned access to l2cap conf data
From: Marcel Holtmann <marcel@holtmann.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-bluetooth@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        steven miao <realmz6@gmail.com>
In-Reply-To: <1287268187-9628-1-git-send-email-vapier@gentoo.org>
References: <1287268187-9628-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 13:51:46 +0200
Message-ID: <1287402706.3316.126.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

> In function l2cap_get_conf_opt() and l2cap_add_conf_opt() the address of
> opt->val sometimes is not at the edge of 2-bytes/4-bytes, so 2-bytes/4 bytes
> access will cause data misalignment exeception.  Use get_unaligned_le16/32
> and put_unaligned_le16/32 function to avoid data misalignment execption.
> 
> Signed-off-by: steven miao <realmz6@gmail.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> was posted a month ago with no feedback ...

must have slipped through. However I don't remember it being on
linux-bluetooth at all. Maybe it was on the other mailing lists :(

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


