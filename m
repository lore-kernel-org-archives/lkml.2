Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab2EPODh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:03:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56849 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab2EPODg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:03:36 -0400
Date: Wed, 16 May 2012 17:03:24 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, dedekind1@gmail.com,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com, tglx@linutronix.de
Subject: Re: [PATCH 1/7] [RFC] UBI: Export next_sqnum()
Message-ID: <20120516170324.337f2932@pixies.home.jungo.com>
In-Reply-To: <1337101871-31181-2-git-send-email-richard@nod.at>
References: <1337101871-31181-1-git-send-email-richard@nod.at>
	<1337101871-31181-2-git-send-email-richard@nod.at>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Tue, 15 May 2012 19:11:05 +0200 Richard Weinberger <richard@nod.at> wrote:
> The fastmap mechanism needs to read the next sequence nummber
> directly.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/ubi/eba.c |   18 +++++++++---------
>  drivers/mtd/ubi/ubi.h |    1 +
>  2 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
> index bd5fdbf..d75677d 100644
> --- a/drivers/mtd/ubi/eba.c
> +++ b/drivers/mtd/ubi/eba.c
> @@ -57,7 +57,7 @@
>   * global sequence counter value. It also increases the global sequence
>   * counter.
>   */
> -static unsigned long long next_sqnum(struct ubi_device *ubi)
> +unsigned long long ubi_next_sqnum(struct ubi_device *ubi)

Minor nit.

Comment above the function should have been changed too.
(look for the "next_sqnum - get next sequence number" comment)

Other than that,
Reviewed-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>

Regards,
Shmulik
