Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1DEFlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 01:41:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39440 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1DEFlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 01:41:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:references:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=ASrLgxV+8ahPhjPWVsyMtLxvUP085qZL5X1kObMqE9eIJZQ/BbOVBtvoTG22gqsx7C
         TC/MphfBxe0Ug+hBQfOECYb7WU/dg6srTBivx5zBIfoimLZoJ/W9+19YOgcqFNhG6pGz
         vhthwSfelC/tFNIhoyCR6hbACA6lxrTwbjwOI=
Date: Tue, 5 Apr 2011 13:41:02 +0800
From: "=?utf-8?B?d2FubG9uZy5nYW8=?=" <wanlong.gao@gmail.com>
To: "=?utf-8?B?RXJpYyBEdW1hemV0?=" <eric.dumazet@gmail.com>
Cc: "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>,
        "=?utf-8?B?UmFmYWVsIEouIFd5c29ja2k=?=" <rjw@sisk.pl>,
        "=?utf-8?B?VGhvbWFzIEdsZWl4bmVy?=" <tglx@linutronix.de>,
        "=?utf-8?B?SW5nbyBNb2xuYXI=?=" <mingo@elte.hu>
References: <201104050339475463862@gmail.com>
Subject: =?utf-8?B?UmU6IFJlOiBYODZfMzI6IEdvdCBhIGtlcm5lbCBwYW5pYyB3aGVuIHBvd2Vyb2Zm?=
Message-ID: <201104051340535622833@gmail.com>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I pulled the linus' tree ,then it goes well .
The issue is seems like you said ,unregister the syscore_ops
But , can you tell me how did you know that ?

Thanks

