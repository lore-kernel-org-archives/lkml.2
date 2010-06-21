Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab0FUN4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:56:45 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:39419 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab0FUN4o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:56:44 -0400
From: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rt2870: add device id for Zyxel NWD-270N
Date: Mon, 21 Jun 2010 16:56:09 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.31.13-131-pae; KDE/4.4.4; i686; ; )
Cc: gregkh@suse.de
References: <1277118056-21367-1-git-send-email-ozan@pardus.org.tr>
In-Reply-To: <1277118056-21367-1-git-send-email-ozan@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006211656.09155.ozan@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pazartesi 21 Haziran 2010 günü (saat 14:00:56) Ozan Çağlayan şunları yazmıştı:
> Add device id for Zyxel NWD-270N USB dongle.
> 
> Signed-off-by: Ozan Çağlayan <ozan@pardus.org.tr>
> ---
>  drivers/staging/rt2860/usb_main_dev.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

This ID is also listed in rt2800usb sources but since there are a dozen of ID 
which conflicts between it and the ones from staging, I sent the patch.

Regards,

---
Ozan Çağlayan
TUBITAK/UEKAE - Pardus Linux
http://www.pardus.org.tr/eng
