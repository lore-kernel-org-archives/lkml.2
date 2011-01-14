Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab1ANBkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 20:40:55 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:34947 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756924Ab1ANBkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 20:40:52 -0500
MIME-Version: 1.0
In-Reply-To: <1294268128-8220-1-git-send-email-omar.ramirez@ti.com>
References: <1294268128-8220-1-git-send-email-omar.ramirez@ti.com>
Date: Thu, 13 Jan 2011 19:40:51 -0600
Message-ID: <AANLkTi=nYTXOvPZoLM1W9-K7Nj_W_uwMFnEdn6fLv_qW@mail.gmail.com>
Subject: Re: [PATCH] staging: tidspbridge: replace mbox callback with notifier_call
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Fernando Guzman Lugo <x0095840@ti.com>,
        Rene Sapiens <rene.sapiens@ti.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Hari Kanigeri <h-kanigeri2@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 5, 2011 at 4:55 PM, Omar Ramirez Luna <omar.ramirez@ti.com> wrote:
> Lately, mailbox callbacks have been replaced by notifier block
> call chains, this needs to be changed in the users of mailbox,
> otherwise compilation will break due to missing parameters.
>
> Reported-by: Hari Kanigeri <h-kanigeri2@ti.com>
> Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>

Pushed to for-gkh-2.6.38 branch.

Regards,

Omar
