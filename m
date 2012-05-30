Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab2E3PQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:16:11 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:49007 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031Ab2E3PQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:16:09 -0400
MIME-Version: 1.0
In-Reply-To: <1338388466-3565-4-git-send-email-kishon@ti.com>
References: <1338388466-3565-1-git-send-email-kishon@ti.com> <1338388466-3565-4-git-send-email-kishon@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Wed, 30 May 2012 20:39:34 +0530
Message-ID: <CAMQu2gyK7MkwLUVmXWjgKLn+QPobEvz7bmLV+BituJkt1=qNmQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] arm: omap: phy: remove unused functions from omap-phy-internal.c
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: tony@atomide.com, linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, balbi@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 8:04 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> All the unnessary functions in omap-phy-internal is removed.
> These functionality are now handled by omap-usb2 phy driver.
>
Cool. One less item in platform code.
