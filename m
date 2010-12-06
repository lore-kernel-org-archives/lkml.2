Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab0LFIvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 03:51:48 -0500
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:44586 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751643Ab0LFIvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 03:51:47 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinnLb9DLMKfxEs_KqMvOmegSDYRuLWh5y=hhBCe@mail.gmail.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com>
	<1288054306-4361-2-git-send-email-x0095840@ti.com>
	<1288054306-4361-3-git-send-email-x0095840@ti.com>
	<1288054306-4361-4-git-send-email-x0095840@ti.com>
	<1288054306-4361-5-git-send-email-x0095840@ti.com>
	<1288054306-4361-6-git-send-email-x0095840@ti.com>
	<1288054306-4361-7-git-send-email-x0095840@ti.com>
	<1288054306-4361-8-git-send-email-x0095840@ti.com>
	<1288054306-4361-9-git-send-email-x0095840@ti.com>
	<AANLkTinnLb9DLMKfxEs_KqMvOmegSDYRuLWh5y=hhBCe@mail.gmail.com>
Date: Mon, 6 Dec 2010 02:51:46 -0600
Message-ID: <AANLkTikkBk5N1v7s4r=4tJiBty1LYu3YpzaMGB=RXLwt@mail.gmail.com>
Subject: Re: [PATCH 8/8] staging: tidspbridge - make sync_wait_on_event interruptible
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: gregkh@suse.de, felipe.contreras@nokia.com, Hiroshi.DOYU@nokia.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 5:17 PM, Guzman Lugo, Fernando
<fernando.lugo@ti.com> wrote:
> So that avoid nonkillable process.
>
> Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> ---
>  .../staging/tidspbridge/include/dspbridge/sync.h   |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)

Pushed to dspbridge.

Regards,

Omar
