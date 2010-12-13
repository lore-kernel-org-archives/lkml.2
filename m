Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab0LMWCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 17:02:42 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:35118 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988Ab0LMWCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 17:02:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=BTXS7Dr261+DCq8+qEwkYDSp33nOiBmikyeUVUbTlxd5KgF1QFyUHEI2MIhPV2hdJ7
         K05ZnsmqqcTCoyhL9x9L271fTiLs+oeO8prTAxCoCTqLyosLGjq3MjcGjqsOR3go5axT
         /+p2MslayH0N9JPh2HrlSVq/axyACjGmJZaLk=
MIME-Version: 1.0
In-Reply-To: <1291882444-1523-1-git-send-email-leoli@freescale.com>
References: <1291882444-1523-1-git-send-email-leoli@freescale.com>
Date: Mon, 13 Dec 2010 14:02:39 -0800
X-Google-Sender-Auth: 8HvYL0PUvpCAg98u_bi3dYztvmE
Message-ID: <AANLkTinvCek5B-4kgnm-A7=xuhS9yK6fjotNKaeO1e=T@mail.gmail.com>
Subject: Re: [PATCH] fsldma: fix issue of slow dma
From: Dan Williams <dan.j.williams@intel.com>
To: Li Yang <leoli@freescale.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 12:14 AM, Li Yang <leoli@freescale.com> wrote:
> From: Forrest Shi <b29237@freescale.com>
>
> Fixed fsl dma slow issue by initializing dma mode register with
> bandwidth control. It boosts dma performance and should works
> with 85xx board.
>
> Signed-off-by: Forrest Shi <b29237@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>

Applied.
