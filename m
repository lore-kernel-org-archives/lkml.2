Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1KPFre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 00:47:34 -0500
Received: from senator.holtmann.net ([87.106.208.187]:48112 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab1KPFrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 00:47:33 -0500
Subject: Re: [PATCH] Bluetooth: Add AR30XX device ID on Asus laptops
From: Marcel Holtmann <marcel@holtmann.org>
To: Keng-Yu Lin <kengyu@canonical.com>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 16 Nov 2011 14:46:46 +0900
In-Reply-To: <1321413683-4502-1-git-send-email-kengyu@canonical.com>
References: <1321413683-4502-1-git-send-email-kengyu@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1321422409.15441.510.camel@aeonflux>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keng-Yu,

> The ID is found on Asus K54HR and K53U.
> Blacklist the AR3011-based device ID [0489:e03d]
> and add to ath3k.c for firmware loading.

please include the output of /proc/bus/usb/devices or usb-devices script
for this hardware before and after firmware loading. I want this as part
of the commit message so we have it for future reference.

Regards

Marcel


