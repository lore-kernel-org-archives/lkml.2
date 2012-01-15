Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab2AONNJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 08:13:09 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49295 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2AONNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 08:13:07 -0500
Subject: Re: [PATCH] UBI: Handle empty string in verify_mkvol_req()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Sun, 15 Jan 2012 15:13:00 +0200
In-Reply-To: <1326463660-17852-1-git-send-email-richard@nod.at>
References: <1326463660-17852-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1326633184.2201.9.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-13 at 15:07 +0100, Richard Weinberger wrote:
> Currently it's possible to create a volume without a name.
> E.g:
> ubimkvol -n 32 -s 2MiB -t static /dev/ubi0 -N ""
> 
> After that vtbl_check() will always fail because it does not permit
> empty strings.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Well-spotted, thank you! I'll send it to Linus soon, as well as the
other patch of yours.

Artem.

