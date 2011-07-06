Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab1GFIpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 04:45:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62324 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab1GFIpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 04:45:22 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20110706103116.1949d632@destiny.ordissimo>
References: <1309921520.26847.3.camel@phoenix> <20110706103116.1949d632@destiny.ordissimo>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 6 Jul 2011 16:45:02 +0800
Message-ID: <CAF+7xWm2rqp2P=N+C6Qu=c5muV7Y5GbB9u=1+qxKVFc9SiGGHQ@mail.gmail.com>
Subject: Re: [PATCH] platform-drivers-x86: msi-wmi: add missing
 sparse_keymap_free in msi_wmi_init error path
To: Anisse Astier <anisse@astier.eu>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>,
        Thomas Renninger <trenn@suse.de>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> PS: It might already have been asked, but what's your secret Axel ? Do
> you use static/dynamic analysis tools ? Which ones ?
>
Actually, I just read the code.
I don't use any special analysis tool, maybe just use grep.

Regards,
Axel
