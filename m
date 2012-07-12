Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030628Ab2GLLDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 07:03:03 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42616 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030357Ab2GLLDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 07:03:01 -0400
MIME-Version: 1.0
In-Reply-To: <87394xhocn.fsf@ti.com>
References: <1341997995-14020-1-git-send-email-tarun.kanti@ti.com>
	<1341997995-14020-3-git-send-email-tarun.kanti@ti.com>
	<87394xhocn.fsf@ti.com>
Date: Thu, 12 Jul 2012 13:03:00 +0200
Message-ID: <CACRpkdZMG_ZHW_eGGrdrJh1SuO_=hOObijzmxG1ob6RoNf_dwg@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio/omap: add *remove* callback in platform_driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Kevin Hilman <khilman@ti.com>
Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>, Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 1:25 AM, Kevin Hilman <khilman@ti.com> wrote:

> There is quite a bit of other things to do in remove to properly cleanup
> what is done in probe.

OK I'm dropping this patch for now...

Yours,
Linus Walleij
