Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab1LRBLh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 20:11:37 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50798 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058Ab1LRBLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 20:11:35 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1324169888-6687-1-git-send-email-marek.vasut@gmail.com>
References: <1324169888-6687-1-git-send-email-marek.vasut@gmail.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Sun, 18 Dec 2011 09:11:12 +0800
Message-ID: <CAF+7xWn+2jeoDiuweWnsoqYdCeAinWF5-jfeSVeGzYJRm5aKXw@mail.gmail.com>
Subject: Re: [PATCH] MXSFB: Fix driver registration
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-kernel@vger.kernel.org, Wolfgang Denk <wd@denx.de>,
        Stefano Babic <sbabic@denx.de>, Shawn Guo <shawn.guo@linaro.org>,
        Huang Shijie <b32955@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/18 Marek Vasut <marek.vasut@gmail.com>:
> The driver should be registered with mxsfb_driver, not with mxsfb_devtype.
> This caused obvious null pointer dereference and crash.

Acked-by: Axel Lin <axel.lin@gmail.com>

Also Cc: Florian Tobias Schandinat
