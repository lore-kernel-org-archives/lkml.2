Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab1IHXvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:51:22 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:44582 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab1IHXvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:51:20 -0400
In-Reply-To: <1315503150-22785-1-git-send-email-peterhuewe@gmx.de>
References: <1315503150-22785-1-git-send-email-peterhuewe@gmx.de>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <469B0939-8CE0-42D6-B8C4-D9B052F53D65@iki.fi>
Cc: Arnaud Patard <apatard@mandriva.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Daniel Kenji Toyama <kenji.toyama@gmail.com>
Content-Transfer-Encoding: 7bit
From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH] staging/xgifb: Remove dead code in vb_def.h
Date: Thu, 8 Sep 2011 22:05:04 +0300
To: Peter Huewe <peterhuewe@gmx.de>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 8.9.2011, at 20.32, Peter Huewe wrote:
> In xgifb/vb_def.h NewScratch is always defined, due to these lines at
> the beginning of the file:
>  #ifndef NewScratch
>  #define NewScratch
>  #endif

This has been already deleted from the driver...

> This patch removes the dead defines in vb_def.h
> Found using undertaker:
> http://vamos.informatik.uni-erlangen.de/trac/undertaker/

Also a lot of those defines have been already deleted recently.
This tool however seems to be useful, so it would be good idea
to recheck the current code when the staging tree is back online.

A.

