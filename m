Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab0LXHna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 02:43:30 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:43362 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775Ab0LXHn3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 02:43:29 -0500
MIME-Version: 1.0
In-Reply-To: <1292880188-5860-1-git-send-email-ernesto@ti.com>
References: <1292880188-5860-1-git-send-email-ernesto@ti.com>
Date: Fri, 24 Dec 2010 01:43:28 -0600
Message-ID: <AANLkTi=yGdxYnNqDCQ0aak-gNmagOd2GNqGHQ+FoVhTf@mail.gmail.com>
Subject: Re: [PATCH] staging: tidspbridge: remove code referred by OPT_ZERO_COPY_LOADER
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Ernesto Ramos <ernesto@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, ohad@wizery.com,
        felipe.contreras@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 20, 2010 at 3:23 PM, Ernesto Ramos <ernesto@ti.com> wrote:
> Remove code referred by OPT_ZERO_COPY_LOADER since it is
> not used.
>
> Signed-off-by: Ernesto Ramos <ernesto@ti.com>
> ---
>  drivers/staging/tidspbridge/dynload/cload.c |   60 +++++++++------------------
>  1 files changed, 20 insertions(+), 40 deletions(-)

Pushed to dspbridge.

Regards,

Omar
