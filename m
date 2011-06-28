Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231Ab1F1R5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:57:55 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36987 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760154Ab1F1R45 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:56:57 -0400
MIME-Version: 1.0
In-Reply-To: <1309224113-21818-2-git-send-email-sergiu@chromium.org>
References: <1309224113-21818-1-git-send-email-sergiu@chromium.org>
	<1309224113-21818-2-git-send-email-sergiu@chromium.org>
Date: Tue, 28 Jun 2011 20:56:56 +0300
Message-ID: <CAEnQRZCVvupUpFzRumgaNO4BL64Ysc3N3CrV+AWEdV3hXF1jLw@mail.gmail.com>
Subject: Re: [PATCH 1/3] char drivers: ramoops default platform device for
 module parameter use
From: Daniel Baluta <daniel.baluta@gmail.com>
To: Sergiu Iordache <sergiu@chromium.org>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +struct platform_device *ramoops_device;

This should be static.

> +
>  static int __init ramoops_init(void)
>  {
> +       /*
> +        * If mem_address and mem_size are set (i.e. the module parameters
> +        * are used) then a default platform driver is created
> +        * as there is no need to configure the platform data elsewhere.
> +        */
> +       if (mem_address && mem_size) {
You should get back to this check after introducing record_size.

thanks,
Daniel.
