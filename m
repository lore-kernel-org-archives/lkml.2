Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab2GXIsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 04:48:05 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:59346 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab2GXIsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 04:48:03 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q6O8lXLk002733, This message is released by code: ctaloc0852
Message-ID: <500E6126.4060604@realsil.com.cn>
Date: Tue, 24 Jul 2012 16:47:34 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, <gregkh@linuxfoundation.org>,
        <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] drivers/misc: Add realtek card reader core driver
References: <1343036558-8189-1-git-send-email-wei_wang@realsil.com.cn> <20120723163340.GA4105@x1.osrc.amd.com> <500DF89E.6090501@realsil.com.cn> <20120724064409.GA15735@liondog.tnic>
In-Reply-To: <20120724064409.GA15735@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年07月24日 14:44, Borislav Petkov 写道:
> Ok, thanks for explaining.
>
> Btw, the SDMMC part rtsx_sdmmc.c doesn't build here:
> http://marc.info/?l=linux-kernel&m=134306261405814&w=2
>
> Thanks.
Hi Borislav:

This problem doesn't happen in my system. Can you tell me your kernel 
version and give me your kernel config?

BR,
wwang
