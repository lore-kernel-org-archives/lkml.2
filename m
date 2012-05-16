Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab2EPOJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:09:23 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60205 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045Ab2EPOJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:09:21 -0400
Date: Wed, 16 May 2012 17:09:15 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, dedekind1@gmail.com,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com, tglx@linutronix.de
Subject: Re: [PATCH 2/7] [RFC] UBI: Export compare_lebs()
Message-ID: <20120516170915.55675b6a@pixies.home.jungo.com>
In-Reply-To: <1337101871-31181-3-git-send-email-richard@nod.at>
References: <1337101871-31181-1-git-send-email-richard@nod.at>
	<1337101871-31181-3-git-send-email-richard@nod.at>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Tue, 15 May 2012 19:11:06 +0200 Richard Weinberger <richard@nod.at> wrote:
> The fastmap mechanism needs this funtion,
> rename it to ubi_compare_lebs() and export it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/ubi/scan.c |    8 ++++----
>  drivers/mtd/ubi/ubi.h  |    4 ++++
>  2 files changed, 8 insertions(+), 4 deletions(-)

Reviewed-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>

Regards,
Shmulik
