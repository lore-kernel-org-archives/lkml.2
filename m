Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab2CMStH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:49:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58341 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab2CMStF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:49:05 -0400
Date: Tue, 13 Mar 2012 22:48:59 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, dg77.kim@samsung.com,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        Jason.Wortham@maxim-ic.com, bruce.e.robertson@intel.com
Subject: Re: [PATCH 0/5] MAX17042 add support for maxim POR procedure
Message-ID: <20120313184859.GA883@oksana.dev.rtsoft.ru>
References: <1327425968-21195-1-git-send-email-dirk.brandewie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1327425968-21195-1-git-send-email-dirk.brandewie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 09:26:03AM -0800, dirk.brandewie@gmail.com wrote:
[..]
> Bruce Robertson (1):
>   max17042: Fix value scaling for VCELL and avgVCELL
> 
> Dirk Brandewie (4):
>   max17042: Align register definitions with data sheet and init appnote
>   max17042: Add POR init procedure from Maxim appnote
>   max17042: Add support for signalling change in SOC
>   max17042: Change capacity property to use reported SOC register
> 
>  drivers/power/max17042_battery.c       |  452 +++++++++++++++++++++++++++++++-
>  include/linux/power/max17042_battery.h |   93 ++++++-
>  2 files changed, 522 insertions(+), 23 deletions(-)

Applied. But the driver is broken anyway, see my other email.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
