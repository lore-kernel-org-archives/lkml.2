Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab2IQNtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:49:19 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53070 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab2IQNtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:49:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120917121831.GA23117@kroah.com>
References: <1347610518-3099-1-git-send-email-peter.senna@gmail.com>
	<20120917121831.GA23117@kroah.com>
Date: Mon, 17 Sep 2012 15:49:15 +0200
Message-ID: <CA+MoWDqux60EpDHZnjt+MGp0U2qxxBdfWX+hF5XbCkt1zfCU-Q@mail.gmail.com>
Subject: Re: [PATCH v2 5/9] drivers/staging/gdm72xx/gdm_sdio.c: Remove useless kfree
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: wharms@bfs.de, kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As I already applid your first patch, care to just send an incremental
> patch that makes the change you did here?

I've just sent a patch for that:
[PATCH] drivers/staging/gdm72xx/gdm_sdio.c: Replace kmalloc+memset for kzalloc

-- 
Peter
