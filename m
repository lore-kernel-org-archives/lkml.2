Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab2BMFdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:33:12 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:41620 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264Ab2BMFdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:33:11 -0500
MIME-Version: 1.0
In-Reply-To: <87ty2yxy3b.fsf@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
	<20120210192416.GW1426@atomide.com>
	<87ty2yxy3b.fsf@ti.com>
Date: Mon, 13 Feb 2012 11:03:09 +0530
Message-ID: <CAC83Zv+TBgKDH=y++AmG+uXj+quOt60U98OY=BO-41SH=6ozYg@mail.gmail.com>
Subject: Re: [PATCH v9 00/25] gpio/omap: driver cleanup and fixes
From: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 11, 2012 at 1:25 AM, Kevin Hilman <khilman@ti.com> wrote:
> Tony Lindgren <tony@atomide.com> writes:
>
> [...]
>
>> ..but are there also some patches in your series that should also be
>> applied separately as fixes for the -rc cycle?
>
> IMO, there aren't any things in this series that fall into the
> regression category.
That's right.
--
Tarun
>
> After I get to a final review and test of this (early next week), I'm
> planning to sent a pull request to Grant.
>
> Kevin
